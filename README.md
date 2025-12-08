📌 CureLink – Smart Healthcare Mobile Application

A cross-platform medical application built using Flutter + Firebase that connects patients, doctors, pharmacies, and integrates an AI medical assistant with real-time chat, appointment scheduling, and a full authentication system.


---

🚀 Features Overview

🔐 Authentication & User Roles

Email/Password Firebase Authentication

Role-based access (Patient / Doctor / Pharmacy)

Secure Firestore rules

Profile creation & onboarding


👨‍⚕️ Doctor Module

Doctor profile + multiple clinics

Schedule management

Send diagnoses & medical reports to patients

Doctor–patient chat integration

Firestore real-time sync

BLoC-driven architecture


🧑‍💊 Patient Module

Advanced doctor search & filtering

Appointment booking

Real-time chat

AI assistant (symptom checker)

View medical reports & prescriptions


🏥 Hospital / Pharmacy Modules

Hospital listing

Medicine browser

Pharmacy ordering essentials

Future API integration ready


🤖 AI Integration

Medical assistant

NLP-based symptom analysis

Integrated inside chat flow


💬 Real-time Chat

Firebase Firestore

Read receipts

Media/image upload via Firebase Storage

Doctor–patient secure channels



---


---

🏗 System Architecture

lib/
├── modules/
│    ├── auth/                  (Login, Register, Role Selection)
│    ├── doctor/                (Doctor Profile, Clinics, Diagnosis)
│    ├── chat/                  (Real-Time Messaging)
│    ├── ai_chat/               (AI Assistant)
│    ├── patient/               (Home, Search, Booking)
│    ├── pharmacy/
│    └── hospital/
│
├── shared/
│    ├── components/
│    ├── bloc_observer.dart
│    └── styles/
│
├── models/
│
└── main.dart

✔ Architecture Pattern

CureLink uses a Modular + Clean Structure with BLoC (Business Logic Component) for state management.
This ensures:

Predictable data flow

Clean separation of UI vs logic

Easy scalability for future features


✔ Backend

Firebase Authentication

Firestore (NoSQL)

Firebase Storage

Cloud Messaging (Notifications)



---

🧪 Testing

Unit tests for core logic

Integration tests for flows

Widget tests for UI

Performance testing (30+ users simulated)

Security testing for Firestore rules



---

🛠 Technologies Used

Area	Technology

Frontend	Flutter + Dart
State Management	BLoC
Backend	Firebase (Auth + Firestore + Storage)
Notifications	Firebase Cloud Messaging
Animations	Lottie
AI	NLP Model Integration
Architecture	Modular Feature-Based Structure



---

📸 Screenshots (Placeholder)

> Replace with your actual app screenshots



Authentication Flow

Doctor Module

Chat Screens

AI Assistant

Booking System



---

🧑‍💻 Team Members & Contribution

Name	Role	Contribution

Ahmed Yasser	Flutter Dev (Auth + Doctor Module)	Built full authentication system, multi-role logic, doctor profiles, scheduling, and Firestore integration
Abdelrahman Omar	Flutter Dev (Onboarding + Home + Pharmacy)	Onboarding, Home UI, pharmacy module
Abdelrahman Magdy	Team Leader	Architecture + Chat + AI Module
Others	Modules	Appointment, Media, Hospital, Storage



---

⚙️ How to Run the Project

1. Clone repo

git clone https://github.com/Abdelrahmanmagdy19/final_project

2. Install packages

flutter pub get

3. Connect Firebase

Add google-services.json (Android)

Add GoogleService-Info.plist (iOS)


4. Run

flutter run


---

📌 Future Enhancements

Full pharmacy ordering + payment

Prescription recognition AI

Offline mode

Web version



---

🛡 Security Notes

Enforced Firestore security rules

Encrypted links for medical files

Token-based authentication

Input validation for all sensitive data



---

📄 License

MIT — Free to use & modify.