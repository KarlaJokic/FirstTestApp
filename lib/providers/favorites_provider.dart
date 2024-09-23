import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Provider za omiljene filmove pohranjene u Firestore-u
final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<Map>>((ref) => FavoritesNotifier());

class FavoritesNotifier extends StateNotifier<List<Map>> {
  FavoritesNotifier() : super([]);

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Učitavanje omiljenih filmova nakon prijave
  Future<void> loadFavorites() async {
    final user = _auth.currentUser;
    if (user == null) return; // Nema prijavljenog korisnika

    final snapshot = await _firestore.collection('favorites').doc(user.uid).get();
    if (snapshot.exists) {
      final data = snapshot.data();
      final movies = data?['movies'] as List<dynamic>? ?? [];
      state = movies.cast<Map>();
    }
  }

  // Dodavanje filma u omiljene
  Future<void> addMovie(Map movie) async {
    final user = _auth.currentUser;
    if (user == null) return; // Nema prijavljenog korisnika

    state = [...state, movie]; // Ažuriramo lokalno stanje

    await _firestore.collection('favorites').doc(user.uid).set({
      'movies': state,
    }, SetOptions(merge: true)); // Pohranjujemo u Firestore
  }

  // Uklanjanje filma iz omiljenih
  Future<void> removeMovie(Map movie) async {
    final user = _auth.currentUser;
    if (user == null) return; // Nema prijavljenog korisnika

    state = state.where((m) => m['id'] != movie['id']).toList(); // Ažuriramo lokalno stanje

    await _firestore.collection('favorites').doc(user.uid).set({
      'movies': state,
    }, SetOptions(merge: true)); // Pohranjujemo u Firestore
  }

  // Provjera je li film omiljen
  bool isFavorite(Map movie) {
    return state.any((m) => m['id'] == movie['id']);
  }
}
