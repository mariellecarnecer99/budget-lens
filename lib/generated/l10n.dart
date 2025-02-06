// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Your financial snapshot`
  String get tagLine {
    return Intl.message(
      'Your financial snapshot',
      name: 'tagLine',
      desc: '',
      args: [],
    );
  }

  /// `Top spends`
  String get breakdown {
    return Intl.message('Top spends', name: 'breakdown', desc: '', args: []);
  }

  /// `Breakdown`
  String get breakdownSmallText {
    return Intl.message(
      'Breakdown',
      name: 'breakdownSmallText',
      desc: '',
      args: [],
    );
  }

  /// `View Analytics`
  String get viewAnalytics {
    return Intl.message(
      'View Analytics',
      name: 'viewAnalytics',
      desc: '',
      args: [],
    );
  }

  /// `Cash Flow`
  String get cashFlow {
    return Intl.message('Cash Flow', name: 'cashFlow', desc: '', args: []);
  }

  /// `Income`
  String get income {
    return Intl.message('Income', name: 'income', desc: '', args: []);
  }

  /// `Balance`
  String get balance {
    return Intl.message('Balance', name: 'balance', desc: '', args: []);
  }

  /// `Expense`
  String get expense {
    return Intl.message('Expense', name: 'expense', desc: '', args: []);
  }

  /// `Transaction History`
  String get transactionHistory {
    return Intl.message(
      'Transaction History',
      name: 'transactionHistory',
      desc: '',
      args: [],
    );
  }

  /// `No data available.`
  String get noData {
    return Intl.message(
      'No data available.',
      name: 'noData',
      desc: '',
      args: [],
    );
  }

  /// `No transactions available.`
  String get noTransactions {
    return Intl.message(
      'No transactions available.',
      name: 'noTransactions',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message('Edit', name: 'edit', desc: '', args: []);
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Add Transaction`
  String get addTransaction {
    return Intl.message(
      'Add Transaction',
      name: 'addTransaction',
      desc: '',
      args: [],
    );
  }

  /// `Edit Transaction`
  String get editTransaction {
    return Intl.message(
      'Edit Transaction',
      name: 'editTransaction',
      desc: '',
      args: [],
    );
  }

  /// `Transaction Name`
  String get transactionName {
    return Intl.message(
      'Transaction Name',
      name: 'transactionName',
      desc: '',
      args: [],
    );
  }

  /// `Transaction Amount`
  String get transactionAmount {
    return Intl.message(
      'Transaction Amount',
      name: 'transactionAmount',
      desc: '',
      args: [],
    );
  }

  /// `Transaction Date (YYYY-MM-DD)`
  String get transactionDate {
    return Intl.message(
      'Transaction Date (YYYY-MM-DD)',
      name: 'transactionDate',
      desc: '',
      args: [],
    );
  }

  /// `Transaction Category`
  String get transactionCategory {
    return Intl.message(
      'Transaction Category',
      name: 'transactionCategory',
      desc: '',
      args: [],
    );
  }

  /// `Transaction Type`
  String get transactionType {
    return Intl.message(
      'Transaction Type',
      name: 'transactionType',
      desc: '',
      args: [],
    );
  }

  /// `Transaction Notes`
  String get transactionNotes {
    return Intl.message(
      'Transaction Notes',
      name: 'transactionNotes',
      desc: '',
      args: [],
    );
  }

  /// `Please select a category`
  String get pleaseSelectCategory {
    return Intl.message(
      'Please select a category',
      name: 'pleaseSelectCategory',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a transaction date`
  String get pleaseEnterTransactionDate {
    return Intl.message(
      'Please enter a transaction date',
      name: 'pleaseEnterTransactionDate',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid date (YYYY-MM-DD)`
  String get pleaseEnterValidDate {
    return Intl.message(
      'Please enter a valid date (YYYY-MM-DD)',
      name: 'pleaseEnterValidDate',
      desc: '',
      args: [],
    );
  }

  /// `Please enter amount`
  String get pleaseEnterAmount {
    return Intl.message(
      'Please enter amount',
      name: 'pleaseEnterAmount',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid number`
  String get pleaseEnterAValidNumber {
    return Intl.message(
      'Please enter a valid number',
      name: 'pleaseEnterAValidNumber',
      desc: '',
      args: [],
    );
  }

  /// `Please enter details`
  String get pleaseEnterDetails {
    return Intl.message(
      'Please enter details',
      name: 'pleaseEnterDetails',
      desc: '',
      args: [],
    );
  }

  /// `Please select a transaction type`
  String get pleaseEnterTransactionType {
    return Intl.message(
      'Please select a transaction type',
      name: 'pleaseEnterTransactionType',
      desc: '',
      args: [],
    );
  }

  /// `Please enter notes`
  String get pleaseEnterNotes {
    return Intl.message(
      'Please enter notes',
      name: 'pleaseEnterNotes',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Submit`
  String get submit {
    return Intl.message('Submit', name: 'submit', desc: '', args: []);
  }

  /// `Confirm Deletion`
  String get confirmDeletion {
    return Intl.message(
      'Confirm Deletion',
      name: 'confirmDeletion',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this transaction?`
  String get areYouSure {
    return Intl.message(
      'Are you sure you want to delete this transaction?',
      name: 'areYouSure',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message('No', name: 'no', desc: '', args: []);
  }

  /// `Yes`
  String get yes {
    return Intl.message('Yes', name: 'yes', desc: '', args: []);
  }

  /// `Manage Settings`
  String get manageSettings {
    return Intl.message(
      'Manage Settings',
      name: 'manageSettings',
      desc: '',
      args: [],
    );
  }

  /// `Currency`
  String get currency {
    return Intl.message('Currency', name: 'currency', desc: '', args: []);
  }

  /// `Categories`
  String get categories {
    return Intl.message('Categories', name: 'categories', desc: '', args: []);
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Top spending categories`
  String get topSpendingCategories {
    return Intl.message(
      'Top spending categories',
      name: 'topSpendingCategories',
      desc: '',
      args: [],
    );
  }

  /// `Your Financial Journey`
  String get financialJourney {
    return Intl.message(
      'Your Financial Journey',
      name: 'financialJourney',
      desc: '',
      args: [],
    );
  }

  /// `Week`
  String get week {
    return Intl.message('Week', name: 'week', desc: '', args: []);
  }

  /// `Month`
  String get month {
    return Intl.message('Month', name: 'month', desc: '', args: []);
  }

  /// `Year`
  String get year {
    return Intl.message('Year', name: 'year', desc: '', args: []);
  }

  /// `Transactions for`
  String get transactionsFor {
    return Intl.message(
      'Transactions for',
      name: 'transactionsFor',
      desc: '',
      args: [],
    );
  }

  /// `Total Spent`
  String get totalSpent {
    return Intl.message('Total Spent', name: 'totalSpent', desc: '', args: []);
  }

  /// `Category`
  String get category {
    return Intl.message('Category', name: 'category', desc: '', args: []);
  }

  /// `Date`
  String get date {
    return Intl.message('Date', name: 'date', desc: '', args: []);
  }

  /// `Manage Categories`
  String get manageCategories {
    return Intl.message(
      'Manage Categories',
      name: 'manageCategories',
      desc: '',
      args: [],
    );
  }

  /// `Add Category`
  String get addCategory {
    return Intl.message(
      'Add Category',
      name: 'addCategory',
      desc: '',
      args: [],
    );
  }

  /// `Enter category name`
  String get enterCatName {
    return Intl.message(
      'Enter category name',
      name: 'enterCatName',
      desc: '',
      args: [],
    );
  }

  /// `Edit Category`
  String get editCategory {
    return Intl.message(
      'Edit Category',
      name: 'editCategory',
      desc: '',
      args: [],
    );
  }

  /// `Edit category name`
  String get editCatName {
    return Intl.message(
      'Edit category name',
      name: 'editCatName',
      desc: '',
      args: [],
    );
  }

  /// `Select Currency`
  String get selectCurrency {
    return Intl.message(
      'Select Currency',
      name: 'selectCurrency',
      desc: '',
      args: [],
    );
  }

  /// `Select Language`
  String get selectLanguage {
    return Intl.message(
      'Select Language',
      name: 'selectLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Account Management`
  String get accountManagement {
    return Intl.message(
      'Account Management',
      name: 'accountManagement',
      desc: '',
      args: [],
    );
  }

  /// `Profile Details`
  String get profileDetails {
    return Intl.message(
      'Profile Details',
      name: 'profileDetails',
      desc: '',
      args: [],
    );
  }

  /// `Password Management`
  String get passwordManagement {
    return Intl.message(
      'Password Management',
      name: 'passwordManagement',
      desc: '',
      args: [],
    );
  }

  /// `Sign Out`
  String get signOut {
    return Intl.message('Sign Out', name: 'signOut', desc: '', args: []);
  }

  /// `Logged out successfully`
  String get loggedOutSuccess {
    return Intl.message(
      'Logged out successfully',
      name: 'loggedOutSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Error logging out`
  String get loggedOutError {
    return Intl.message(
      'Error logging out',
      name: 'loggedOutError',
      desc: '',
      args: [],
    );
  }

  /// `Profile updated successfully!`
  String get profileUpdateSuccess {
    return Intl.message(
      'Profile updated successfully!',
      name: 'profileUpdateSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message('Profile', name: 'profile', desc: '', args: []);
  }

  /// `Full Name`
  String get fullName {
    return Intl.message('Full Name', name: 'fullName', desc: '', args: []);
  }

  /// `Please enter your full name`
  String get pleaseEnterFullName {
    return Intl.message(
      'Please enter your full name',
      name: 'pleaseEnterFullName',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Bio`
  String get bio {
    return Intl.message('Bio', name: 'bio', desc: '', args: []);
  }

  /// `Update Profile`
  String get updateProfile {
    return Intl.message(
      'Update Profile',
      name: 'updateProfile',
      desc: '',
      args: [],
    );
  }

  /// `Password updated successfully!`
  String get passwordUpdateSuccess {
    return Intl.message(
      'Password updated successfully!',
      name: 'passwordUpdateSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Current Password`
  String get currentPassword {
    return Intl.message(
      'Current Password',
      name: 'currentPassword',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your current password`
  String get pleaseEnterPassword {
    return Intl.message(
      'Please enter your current password',
      name: 'pleaseEnterPassword',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get newPassword {
    return Intl.message(
      'New Password',
      name: 'newPassword',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your new password`
  String get pleaseEnterNewPassword {
    return Intl.message(
      'Please enter your new password',
      name: 'pleaseEnterNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 6 characters long`
  String get passwordValidation {
    return Intl.message(
      'Password must be at least 6 characters long',
      name: 'passwordValidation',
      desc: '',
      args: [],
    );
  }

  /// `Confirm New Password`
  String get confirmNewPassword {
    return Intl.message(
      'Confirm New Password',
      name: 'confirmNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Please confirm your new password`
  String get pleaseConfirmNewPassword {
    return Intl.message(
      'Please confirm your new password',
      name: 'pleaseConfirmNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get passwordsDoNotMatch {
    return Intl.message(
      'Passwords do not match',
      name: 'passwordsDoNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get changePassword {
    return Intl.message(
      'Change Password',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'hi'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
