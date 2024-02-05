# Aplikacja do monitorowania samopoczucia "CareMyMind"

## Spis treści

- [Wprowadzenie](#wprowadzenie)
- [Funkcje](#funkcje)
- [Technologie](#technologie)
- [Wymagania wstępne](#wymagania-wstępne)
- [Instalacja](#instalacja)
- [Katalogi projektu](#katalogu-projektu)
- [Testowanie](#testowanie)


## Wprowadzenie

Aplikacja wspomagająca użytkownika w monitorowaniu samopoczucia, napisana w języku Dart przy wykorzystaniu technologii Flutter,
aplikacja przewidziana została do działania na platformach Android i iOS.  

## Funkcje

Kluczowe funkcjonalności zaimplementowane w aplikacji:

- Możliwość logowania/rejestracji konta użytkownika z wykorzystaniem sieciowej usługi Firebase
- Możliwość dodawania oraz wyświetlania wpisów z sieciowej bazy usługi Firebase
- Wyświetlanie szczegółowych wykresów samopoczucia dla każdego użytkownika
- Możliwość zmiany motywu kolorystycznego aplikacji
- Implementacja prostych ćwiczeń oddechowych

## Technologie

Technologie wykorzystane w projekcie:

- Flutter 3.16.2
- Dart 3.2.2
- Flutter DevTools 2.28.3
- Firebase 13.0.3 (wykorzystano moduły: Firestore, Authentication, Storage, Messaging, Functions)

## Wymagania wstępne

Do uruchomienia projektu potrzebne jest:

- Środowisko skonfigurowane na potrzeby projektów Flutter (VS Code, Android Studio, Xcode) 
-> [Oficjalna instrukcja instalacji środowiska Flutter](https://docs.flutter.dev/get-started/install)

## Instalacja

```bash
git clone https://github.com/wzorek2000/firstone.git
cd firstone
flutter pub get
flutter run
```

W zależności od wykorzystywanego urządzenia może być konieczne dodatkowe zastosowanie komendy:
```bash
flutter clean
```

i ponowne wykonanie komend:
```bash
flutter pub get
flutter run
```

## Katalogi projektu

- ../android - zawiera konfiguracje środowiska Android
- ../ios - zawiera konfigurację środowiska iOS
- ../lib - zawiera kod żródłowy aplikacji
- ../test_driver - zawiera kod źródłowy testów automatycznych aplikacji

## Testowanie

W katalogu ../test_driver znajdują się utworzone na potrzeby projektu testy automatyczne aplikacji.
Aby uruchomić testy należy najpierw wystartować urządzenie testowe przy pomocy polecenia:

```bash
flutter drive --target=test_driver/app_test.dart
```

Następnie w pliku app_test.dart można uruchamiać wszystkie utworzone testy.