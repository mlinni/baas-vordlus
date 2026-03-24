# BaaS Platvormide Võrdlus: Näidisrakendus

See repositoorium sisaldab minimaalset Flutteri näidisrakendust, mis loodi osana Tallinna Tehnikaülikooli (TalTech) IT-süsteemide administreerimise (IAAB) bakalaureusetööst. Töös võrreldakse kolme populaarse *Backend-as-a-Service* (BaaS) platvormi: **Supabase**, **Firebase** ja **AWS Amplify**.

## Eesmärk

Rakenduse eesmärk ei ole olla funktsionaalselt täiuslik lõpptoode, vaid pakkuda **standartset ja identset kasutajaliidest (UI)**, mille peal testida erinevate pilveplatvormide seadistamise keerukust, jõudlust ja haldusmugavust. 

Rakenduses on realiseeritud järgmised põhifunktsionaalsused (mida testitakse iga BaaS platvormiga eraldi):
- Kasutaja autentimine (E-mail ja parool)
- Andmebaasi CRUD operatsioonid (profiili andmete salvestamine ja lugemine)
- Failide hoiustamine (pildi üleslaadimine)

## Tehnoloogiad
- **Raamistik:** Flutter (Dart)
- **Pilveplatvormid:** - [Supabase](https://supabase.com/)
  - [Firebase](https://firebase.google.com/)
  - [AWS Amplify](https://aws.amazon.com/amplify/)

## Arhitektuur

Projekt kasutab lihtsustatud *Repository* mustrit, mis võimaldab äriloogika (BaaS suhtlus) hoida kasutajaliidesest eraldi. See tagab, et UI kood jääb kõigi kolme platvormi testimisel samaks ning muutub vaid taustateenuse liidestus.

```text
lib/
│
├── main.dart               # Rakenduse sisenemispunkt
├── ui/                     # Kasutajaliidese ekraanid (Login, Home jne)
│
└── services/               # Pilveteenuste integratsioonid
    ├── auth_interface.dart # Ühine liides (Interface) autentimiseks
    ├── supabase_auth.dart  # Supabase'i spetsiifiline kood
    ├── firebase_auth.dart  # Firebase'i spetsiifiline kood
    └── amplify_auth.dart   # AWS Amplify spetsiifiline kood
