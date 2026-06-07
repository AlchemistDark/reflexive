import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:markdown/markdown.dart' as md;

/// A [MarkdownElementBuilder] for rendering LaTeX math formulas.
class MathBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    final text = element.textContent.trim();
    if (text.isEmpty) return null;

    final bool isDisplay = element.attributes['display'] == 'true';

    final mathWidget = Math.tex(
      text,
      textStyle: preferredStyle?.copyWith(
        fontSize: isDisplay ? 17 : (preferredStyle.fontSize ?? 14),
        color: preferredStyle.color ?? Colors.black87,
      ),
      mathStyle: isDisplay ? MathStyle.display : MathStyle.text,
      onErrorFallback: (err) => Text(
        text,
        style: const TextStyle(color: Colors.red),
      ),
    );

    if (!isDisplay) return mathWidget;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: mathWidget,
        ),
      ),
    );
  }
}

/// Robust math syntax for the markdown parser.
class LaTeXSettings {
  static List<md.InlineSyntax> get inlineSyntaxes => [
        // Inline math: $...$
        MathSyntax(r'\$((?:\\.|[^$])+)\$'),
        // Inline math: \(...\)
        MathSyntax(r'\\\(((?:\\.|[^\)])+)\\\)'),
        // Block math as inline: \[...\]
        MathSyntax(r'\\\[((?:\\.|[^\]])+)\\\]', display: true),
        // Block math as inline: $$...$$
        MathSyntax(r'\$\$((?:\\.|[^\$])+)\$\$', display: true),
      ];

  static List<md.BlockSyntax> get blockSyntaxes => [
        const MathBlockSyntax(),
      ];
}

class MathSyntax extends md.InlineSyntax {
  final bool display;
  MathSyntax(super.pattern, {this.display = false});

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    final formula = match.group(match.groupCount) ?? '';
    final element = md.Element('latex', [md.Text(formula.trim())]);
    if (display) {
      element.attributes['display'] = 'true';
    }
    parser.addNode(element);
    return true;
  }
}

class MathBlockSyntax extends md.BlockSyntax {
  // Matches start of block: $$ or \[
  @override
  RegExp get pattern => RegExp(r'^(\$\$|\\\[)');

  const MathBlockSyntax();

  @override
  md.Node? parse(md.BlockParser parser) {
    final firstLine = parser.current.content;
    
    // 1. Single-line block: $$ formula $$ or \[ formula \]
    final oneLineMatch = RegExp(r'^(\$\$|\\\[)(.*?)(\$\$|\\\])$').firstMatch(firstLine.trim());
    if (oneLineMatch != null) {
      parser.advance();
      // Wrapping in 'p' prevents the "Null check operator" crash in flutter_markdown
      return md.Element('p', [
        md.Element('latex', [md.Text(oneLineMatch.group(2)!.trim())])
          ..attributes['display'] = 'true'
      ]);
    }

    // 2. Multi-line block
    final lines = <String>[];
    String endDelim = firstLine.trim().startsWith(r'$$') ? r'$$' : r'\]';
    
    // Extract content from the first line (after delimiter)
    var firstLineContent = firstLine.trim();
    if (firstLineContent.startsWith(r'$$')) {
      firstLineContent = firstLineContent.substring(2);
    } else if (firstLineContent.startsWith(r'\[')) {
      firstLineContent = firstLineContent.substring(2);
    }
    
    if (firstLineContent.isNotEmpty) lines.add(firstLineContent);
    
    parser.advance();
    while (!parser.isDone) {
      final line = parser.current.content;
      if (line.contains(endDelim)) {
        final endIdx = line.indexOf(endDelim);
        final beforeEnd = line.substring(0, endIdx);
        if (beforeEnd.trim().isNotEmpty) lines.add(beforeEnd);
        parser.advance();
        break;
      }
      lines.add(line);
      parser.advance();
    }
    
    return md.Element('p', [
      md.Element('latex', [md.Text(lines.join('\n').trim())])
        ..attributes['display'] = 'true'
    ]);
  }
}
