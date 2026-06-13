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

/// Robust math settings for the markdown parser.
class LaTeXSettings {
  static List<md.InlineSyntax> get inlineSyntaxes => [
        // Inline math: \( ... \) or \\( ... \\)
        MathSyntax(r'\\\\\\\((.*?)\\\\\\\)'),
        MathSyntax(r'\\\\\((.*?)\\\\\)'),
        MathSyntax(r'\\\((.*?)\\\)'),
        // Inline math: $ ... $
        MathSyntax(r'\$((?:\$|[^$])+)\$'),
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
    // Usually the formula is in group 1
    final formula = match.group(1) ?? match.group(0) ?? '';
    
    // Clean up delimiters if they were captured
    String cleanFormula = formula;
    if (cleanFormula.startsWith(r'\(') && cleanFormula.endsWith(r'\)')) {
      cleanFormula = cleanFormula.substring(2, cleanFormula.length - 2);
    } else if (cleanFormula.startsWith(r'$') && cleanFormula.endsWith(r'$')) {
      cleanFormula = cleanFormula.substring(1, cleanFormula.length - 1);
    }

    if (cleanFormula.isEmpty) return false;

    final element = md.Element('latex', [md.Text(cleanFormula.trim())]);
    if (display) {
      element.attributes['display'] = 'true';
    }
    parser.addNode(element);
    return true;
  }
}

class MathBlockSyntax extends md.BlockSyntax {
  @override
  RegExp get pattern => RegExp(r'^\s*(\$\$|\\\[|\\begin\{)');

  const MathBlockSyntax();

  @override
  md.Node? parse(md.BlockParser parser) {
    final firstLine = parser.current.content;
    final firstLineTrimmed = firstLine.trim();

    String? endDelim;
    bool isStandardDelim = false;

    if (firstLineTrimmed.startsWith(r'$$')) {
      endDelim = r'$$';
      isStandardDelim = true;
    } else if (firstLineTrimmed.startsWith(r'\[')) {
      endDelim = r'\]';
      isStandardDelim = true;
    } else if (firstLineTrimmed.startsWith(r'\begin{')) {
      final match = RegExp(r'\\begin\{([a-z*]+)\}').firstMatch(firstLineTrimmed);
      if (match != null) {
        endDelim = '\\end{${match.group(1)}}';
      }
    }

    endDelim ??= r'$$';

    final lines = <String>[];
    String content = firstLine;

    if (isStandardDelim) {
      final startDelim = firstLineTrimmed.startsWith(r'$$') ? r'$$' : r'\[';
      final startIdx = content.indexOf(startDelim);
      content = content.substring(startIdx + startDelim.length);
    }

    if (content.contains(endDelim)) {
      final endIdx = content.indexOf(endDelim);
      if (isStandardDelim) {
        final formula = content.substring(0, endIdx);
        if (formula.trim().isNotEmpty) lines.add(formula);
      } else {
        lines.add(firstLine);
      }
      parser.advance();
    } else {
      if (isStandardDelim) {
        if (content.trim().isNotEmpty) lines.add(content);
      } else {
        lines.add(firstLine);
      }
      parser.advance();

      while (!parser.isDone) {
        final line = parser.current.content;
        if (line.contains(endDelim)) {
          final endIdx = line.indexOf(endDelim);
          if (isStandardDelim) {
            final beforeEnd = line.substring(0, endIdx);
            if (beforeEnd.trim().isNotEmpty) lines.add(beforeEnd);
          } else {
            lines.add(line);
          }
          parser.advance();
          break;
        }
        lines.add(line);
        parser.advance();
      }
    }

    return md.Element('p', [
      md.Element('latex', [md.Text(lines.join('\n').trim())])
        ..attributes['display'] = 'true'
    ]);
  }
}
