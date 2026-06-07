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

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Math.tex(
            text,
            textStyle: preferredStyle?.copyWith(
              fontSize: 17,
              color: preferredStyle.color ?? Colors.black87,
            ),
            mathStyle: MathStyle.display,
            onErrorFallback: (err) => Text(
              text,
              style: const TextStyle(color: Colors.red),
            ),
          ),
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
        MathSyntax(r'\\\[((?:\\.|[^\]])+)\\\]'),
        // Block math as inline: $$...$$
        MathSyntax(r'\$\$((?:\\.|[^\$])+)\$\$'),
      ];

  static List<md.BlockSyntax> get blockSyntaxes => [
        const MathBlockSyntax(),
      ];
}

class MathSyntax extends md.InlineSyntax {
  MathSyntax(String pattern) : super(pattern);

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    // Content is in the last capturing group
    final formula = match.group(match.groupCount) ?? '';
    parser.addNode(md.Element('latex', [md.Text(formula.trim())]));
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
      return md.Element('latex', [md.Text(oneLineMatch.group(2)!.trim())]);
    }

    // 2. Multi-line block
    final lines = <String>[];
    String endDelim = firstLine.trim().startsWith(r'$$') ? r'$$' : r'\]';
    
    // Extract content from the first line (after delimiter)
    var firstLineContent = firstLine.trim();
    if (firstLineContent.startsWith(r'$$')) firstLineContent = firstLineContent.substring(2);
    else if (firstLineContent.startsWith(r'\[')) firstLineContent = firstLineContent.substring(2);
    
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
    
    return md.Element('latex', [md.Text(lines.join('\n').trim())]);
  }
}
