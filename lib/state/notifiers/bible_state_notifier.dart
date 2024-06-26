import 'dart:async';

import 'package:bible_repository/bible_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'bible_state_notifier.freezed.dart';

@freezed
class VerseState with _$VerseState {
  const factory VerseState({
    required int chapter,
    required int verse,
    required String name,
    required String text,
    required bool selected,
  }) = _VerseState;

  const VerseState._();
}

@freezed
class ChapterState with _$ChapterState {
  const factory ChapterState({
    required int chapter,
    required List<VerseState> verses,
  }) = _ChapterState;

  const ChapterState._();
}

@freezed
class BookState with _$BookState {
  const factory BookState({
    required String name,
    required BookReferenceId referenceId,
    required List<ChapterState> chapters,
  }) = _BookState;

  const BookState._();

  ChapterState getChapterByNumber(int number) {
    return chapters.firstWhere((chapter) => chapter.chapter == number);
  }
}

@freezed
class BibleState with _$BibleState {
  const factory BibleState({
    required String name,
    required List<BookState> books,
  }) = _BibleState;

  const BibleState._();

  BookState getBookByReferenceId(BookReferenceId referenceId) {
    return books.firstWhere((book) => book.referenceId == referenceId);
  }

  BookState? getBookByReferenceIdString(String? referenceIdString) {
    final referenceId = referenceIdString != null
        ? BookReferenceId.fromString(referenceIdString)
        : null;
    return books.firstWhere((book) => book.referenceId == referenceId);
  }
}

class BibleStateNotifier extends AsyncNotifier<BibleState> {
  @override
  FutureOr<BibleState> build() {
    return _loadBible();
  }

  Future<void> toggleVerseSelected(
    BookReferenceId referenceId,
    int chapterNumber,
    int verseNumber,
  ) async {
    await update((state) => state.copyWith(
          books: state.books.map((book) {
            if (book.referenceId != referenceId) {
              return book;
            }
            return book.copyWith(
              chapters: book.chapters.map((chapter) {
                if (chapter.chapter != chapterNumber) {
                  return chapter;
                }
                return chapter.copyWith(
                  verses: chapter.verses.map((verse) {
                    if(verse.verse != verseNumber) {
                      return verse;
                    }
                    return verse.copyWith(
                      selected: !verse.selected
                    );
                  }).toList(),
                );
              }).toList(),
            );
          }).toList(),
        ));
  }

  Future<BibleState> _loadBible() async {
    final bibleModel = await ref.read(bibleRepositoryProvider).loadBible();
    return BibleState(
      name: bibleModel.name,
      books: bibleModel.books
          .map(
            (bookDTO) => BookState(
              name: bookDTO.name,
              referenceId: bookDTO.referenceId,
              chapters: bookDTO.chapters
                  .map(
                    (chapterDTO) => ChapterState(
                      chapter: chapterDTO.chapter,
                      verses: chapterDTO.verses
                          .map(
                            (verseDTO) => VerseState(
                              chapter: verseDTO.chapter,
                              verse: verseDTO.verse,
                              name: verseDTO.name,
                              text: verseDTO.text,
                              selected: false,
                            ),
                          )
                          .toList(),
                    ),
                  )
                  .toList(),
            ),
          )
          .toList(),
    );
  }
}
