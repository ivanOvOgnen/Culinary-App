import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Recipe {
  final String id;
  final String name;
  final String description;
  final String image;
  final List<String> ingredients;
  final List<String> instructions;

  Recipe({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.ingredients,
    required this.instructions,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'ingredients': ingredients,
      'instructions': instructions,
      'timestamp': FieldValue.serverTimestamp(),
    };
  }

  factory Recipe.fromMap(Map<String, dynamic> map, String id) {
    return Recipe(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      image: map['image'] ?? '',
      ingredients: List<String>.from(map['ingredients'] ?? []),
      instructions: List<String>.from(map['instructions'] ?? []),
    );
  }
}

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  String? get _userId => _auth.currentUser?.uid;
  
  String get _favoritesCollection => 
      dotenv.env['FAVORITES_COLLECTION'] ?? 'favorites';

  CollectionReference? get _userFavoritesRef {
    if (_userId == null) return null;
    return _firestore
        .collection(_favoritesCollection)
        .doc(_userId)
        .collection('recipes');
  }

  Future<void> addToFavorites(Recipe recipe) async {
    if (_userId == null) throw Exception('User not logged in');
    
    try {
      await _userFavoritesRef!
          .doc(recipe.id)
          .set(recipe.toMap());
    } catch (e) {
      print('Error adding to favorites: $e');
      rethrow;
    }
  }

  Future<void> removeFromFavorites(String recipeId) async {
    if (_userId == null) throw Exception('User not logged in');
    
    try {
      await _userFavoritesRef!
          .doc(recipeId)
          .delete();
    } catch (e) {
      print('Error removing from favorites: $e');
      rethrow;
    }
  }

  Future<bool> isFavorite(String recipeId) async {
    if (_userId == null) return false;
    
    try {
      final doc = await _userFavoritesRef!
          .doc(recipeId)
          .get();
      return doc.exists;
    } catch (e) {
      print('Error checking favorite: $e');
      return false;
    }
  }

  Stream<List<Recipe>> getFavorites() {
    if (_userId == null) return Stream.value([]);
    
    return _userFavoritesRef!
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Recipe.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    });
  }

  Future<void> toggleFavorite(Recipe recipe) async {
    final isFav = await isFavorite(recipe.id);
    if (isFav) {
      await removeFromFavorites(recipe.id);
    } else {
      await addToFavorites(recipe);
    }
  }
}