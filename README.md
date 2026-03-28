# BaaS Platvormide Võrdlus: Näidisrakendus

See repositoorium sisaldab minimaalset Flutteri näidisrakendust, mis luuakse osana Tallinna Tehnikaülikooli (TalTech) IT-süsteemide administreerimise (IAAB) bakalaureusetööst. Töös võrreldakse kolme populaarse *Backend-as-a-Service* (BaaS) platvormi: **Supabase**, **Firebase** ja **AWS Amplify**.

## Eesmärk

Rakenduse eesmärk ei ole olla funktsionaalselt täiuslik lõpptoode, vaid pakkuda **standardset ja identset kasutajaliidest (UI)**, mille peal testida erinevate pilveplatvormide seadistamise keerukust, jõudlust ja haldusmugavust.

Rakenduses realiseeritakse järgmised põhifunktsionaalsused, mida testitakse iga BaaS platvormiga eraldi:
- kasutaja autentimine e-posti ja parooliga
- andmebaasi CRUD operatsioonid profiili andmete salvestamiseks ja lugemiseks
- failide hoiustamine pildi üleslaadimise kaudu

## Tehnoloogiad

- **Raamistik:** Flutter (Dart)
- **Pilveplatvormid:**
  - [Supabase](https://supabase.com/)
  - [Firebase](https://firebase.google.com/)
  - [AWS Amplify](https://aws.amazon.com/amplify/)

## Arhitektuur

Projekt kasutab lihtsustatud *Repository* mustrit, mille eesmärk on hoida kasutajaliides ja BaaS platvormi spetsiifiline loogika teineteisest lahus. See võimaldab kasutada kõigi kolme platvormi testimisel sama UI-d ja sama rakenduse voogu ning vahetada ainult taustateenuse implementatsiooni.

Arhitektuuri põhimõtted:

- UI kiht ei suhtle otse Supabase'i, Firebase'i ega Amplify SDK-dega.
- Äriloogika sõltub ainult ühistest liidestest.
- Iga BaaS platvorm realiseerib samad repository-liidesed.
- Võrdlus jääb ausaks, sest muutub ainult teenuse adapter, mitte kasutajavoog.

Esialgne kaustastruktuur:

```text
lib/
│
├── main.dart                        # Rakenduse sisenemispunkt
├── app/                             # Rakenduse algseadistus, route'id, DI
├── models/                          # Lihtsad domeenimudelid
├── repositories/                    # Ühised repository liidesed
│   ├── auth_repository.dart
│   ├── profile_repository.dart
│   └── storage_repository.dart
├── services/                        # BaaS implementatsioonid
│   ├── supabase/
│   │   ├── supabase_auth_repository.dart
│   │   ├── supabase_profile_repository.dart
│   │   └── supabase_storage_repository.dart
│   ├── firebase/
│   │   ├── firebase_auth_repository.dart
│   │   ├── firebase_profile_repository.dart
│   │   └── firebase_storage_repository.dart
│   └── amplify/
│       ├── amplify_auth_repository.dart
│       ├── amplify_profile_repository.dart
│       └── amplify_storage_repository.dart
└── ui/
    ├── login_screen.dart
    ├── home_screen.dart
    ├── profile_screen.dart
    └── upload_screen.dart
```

## Teostusplaan

Rakenduse arendus toimub etapiviisiliselt, et hoida võrdlus kontrollitud ja tehniline keerukus võimalikult väike.

### 1. Minimaalse rakenduse karkassi loomine

Esimeses etapis luuakse uus puhas Flutteri näidisrakendus koos minimaalse kaustastruktuuriga. Selles etapis ei seota rakendust veel ühegi BaaS platvormiga.

Tulemus:
- rakendus käivitub
- põhiline projektistruktuur on paigas
- UI ja andmekiht on eraldatud

### 2. Ühiste liideste ja mudelite defineerimine

Teises etapis defineeritakse rakenduse ühised domeenimudelid ja repository-liidesed.

Esialgsed liidesed:
- `AuthRepository`
- `ProfileRepository`
- `StorageRepository`

Tulemus:
- rakenduse ülejäänud kihid sõltuvad liidestest, mitte konkreetsest teenusest
- kõigi BaaS platvormide jaoks tekib sama tehniline lähteülesanne

### 3. Backendist sõltumatu UI loomine

Kolmandas etapis ehitatakse valmis minimaalne kasutajavoog, mis kasutab esialgu ainult mock või fake implementatsioone.

Esialgsed vaated:
- sisselogimise vaade
- avaleht
- profiili vaatamise ja muutmise vaade
- pildi üleslaadimise vaade

Tulemus:
- kasutajaliides töötab ilma päris pilveteenuseta
- rakenduse voog on valideeritud enne platvormispetsiifilise loogika lisamist

### 4. Esimese BaaS integratsiooni lisamine

Neljandas etapis realiseeritakse repository-liidesed ühe platvormi jaoks. Esimese kandidaadina kasutatakse Supabase'i, kuna see sobib hästi kiireks prototüüpimiseks ja katab vajalikud funktsioonid.

Tulemus:
- autentimine töötab päris teenusega
- profiili andmeid saab salvestada ja lugeda
- pildi üleslaadimine toimib

### 5. Ülejäänud platvormide lisamine

Pärast esimese integratsiooni stabiliseerimist lisatakse Firebase'i ja AWS Amplify adapterid sama liidesepinna vastu.

Tulemus:
- sama UI ja sama voog töötavad kolme erineva BaaS platvormiga
- võrdlus muutub tehniliselt ühtlaseks

### 6. Võrdlus ja mõõdikud

Lõppfaasis hinnatakse platvorme ühtsete kriteeriumide alusel.

Autentimise võrdluses kasutatakse eelnevalt loodud testkasutajaid ning
põhimõõdikuna käsitletakse ainult olemasoleva kasutaja esimest edukat
emaili ja parooliga sisselogimist. Registreerimise voog ei kuulu selle
konkreetse mõõdiku hulka, et hoida platvormide vaheline võrdlus ühtlane.

Võimalikud võrdlusmõõdikud:
- seadistamise keerukus
- arenduseks kulunud aeg
- koodi maht ja keerukus
- autentimise teostamise lihtsus
- andmebaasioperatsioonide realiseerimise lihtsus
- failide hoiustamise mugavus
- arendajakogemuse üldine kvaliteet

## Esimene praktiline samm

Arenduse esimene praktiline eesmärk on luua töötav Flutteri projekt, kus on:

- minimaalne rakenduse karkass
- ühised repository-liidesed
- fake implementatsioonid
- kaks esmast vaadet: sisselogimine ja profiil

See loob tugeva baasi, mille peale saab hiljem lisada Supabase'i, Firebase'i ja Amplify adapterid ilma UI-d ümber kirjutamata.
