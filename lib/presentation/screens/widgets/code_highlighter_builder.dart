import 'package:flutter/material.dart';
import 'package:flutter_highlighter/flutter_highlighter.dart';
import 'package:flutter_highlighter/themes/atom-one-dark.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markdown/markdown.dart' as md;

/// A [MarkdownElementBuilder] that provides syntax highlighting for code blocks.
class CodeHighlighterBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    var language = '';

    if (element.attributes.containsKey('class')) {
      var lg = element.attributes['class'] as String;
      language = lg.substring(9);
    }

    return SizedBox(
      width: double.infinity,
      child: HighlightView(
        element.textContent.trim(),
        language: language,
        theme: atomOneDarkTheme,
        padding: const EdgeInsets.all(8),
        textStyle: GoogleFonts.robotoMono(
          fontSize: 14,
        ),
      ),
    );
  }
}
