class HospitalModel {
  final String id;
  final String name;
  final String locationAddress;
  final String openingTime;
  final bool is24Hours;
  final double latitude;
  final double longitude;
  final String imagePath;
  final String phoneNumber;
  final String specialty;
  final String description;

  HospitalModel({
    required this.id,
    required this.name,
    required this.locationAddress,
    required this.openingTime,
    required this.imagePath,
    this.is24Hours = false,
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.phoneNumber = 'N/A',
    this.specialty = 'General',
    required this.description,
  });

  static List<HospitalModel> famousHospitals = [
    HospitalModel(
      id: 'CA001',
      name: 'Qasr El Einy New Educational Hospital',
      imagePath:
          'https://www.vinci-construction-projets.com/wp-content/uploads/2016/07/s1-3-780x464.jpeg',
      locationAddress: 'Al Manial, Sayeda Zeinab',
      openingTime: '08:00 AM',
      is24Hours: true,
      latitude: 30.0387,
      longitude: 31.2291,
      phoneNumber: '+20-22-364-7500',
      specialty: 'University/Multi-Specialty',
      description:
          'A major teaching hospital affiliated with Cairo University, known for its extensive range of specialized medical services and academic excellence.',
    ),

    HospitalModel(
      id: 'GZ001',
      name: 'Dar Al Fouad Hospital',
      locationAddress: 'Sheikh Zayed, 6th of October',
      imagePath:
          'https://daralfouadnasrcity.alameda-hc.com/wp-content/uploads/sites/3/2024/06/1.jpg',
      openingTime: '08:00 AM',
      is24Hours: true,
      latitude: 30.0163,
      longitude: 30.9858,
      phoneNumber: '+20-22-667-8900',
      specialty: 'Private/Multi-Specialty',
      description:
          'One of Egypt\'s premier private medical facilities, offering high-quality patient care, particularly noted for its cardiac surgery and treatment centers.',
    ),

    HospitalModel(
      id: 'ALX001',
      name: 'Shatby University Children\'s Hospital',
      locationAddress: 'Shatby, Alexandria',
      imagePath:
          'https://images.healtheg.com//Images/3278/Screenshot_526fae5fb-fbef-4820-ac95-81ef0044c3f9.jpg',
      openingTime: '09:00 AM',
      is24Hours: true,
      latitude: 31.2110,
      longitude: 29.9192,
      phoneNumber: '+20-35-925-500',
      specialty: 'University/Pediatrics',
      description:
          'The largest specialized pediatric hospital in Alexandria, dedicated to providing comprehensive healthcare and surgical services for children.',
    ),

    HospitalModel(
      id: 'QLY001',
      name: 'Benha University Hospital',
      locationAddress: 'Benha, Qalyubia',
      openingTime: '08:00 AM',
      imagePath: 'https://staticfpu.bu.edu.eg/NewsImgs/1593939496.jpg',
      is24Hours: true,
      phoneNumber: '+20-13-322-2500',
      specialty: 'University/Multi-Specialty',
      description:
          'The main teaching and medical reference center for the Qalyubia governorate, offering a wide array of general and specialized medical departments.',
    ),

    HospitalModel(
      id: 'DKH001',
      name: 'Mansoura Urology and Nephrology Center',
      locationAddress: 'Mansoura, Dakahlia',
      imagePath:
          'https://lh3.googleusercontent.com/gps-cs-s/AG0ilSySs6yPcbT92-DhScZcCF1lvht0-Emg6OvQ06ExWi0q95iPlu0YlLG2oCR-LIyCOg_e78xmJAUYT6_u1MT0UmnwRgP8C-VRk2cWmctYwG4N_OMdai7IHlmKLd9f9E_TlvlXD0XF=s1360-w1360-h1020-rw',
      openingTime: '08:00 AM',
      is24Hours: true,
      phoneNumber: '+20-50-223-4567',
      specialty: 'Specialized/Urology & Nephrology',
      description:
          'Globally recognized center for kidney diseases and urology. It performs advanced transplant surgeries and research, serving patients regionally and internationally.',
    ),

    HospitalModel(
      id: 'SHR001',
      name: 'Zagazig University Hospital',
      locationAddress: 'Zagazig, Sharqia',
      openingTime: '08:00 AM',
      imagePath:
          'https://lh3.googleusercontent.com/p/AF1QipOoI17Q_E1fnwvClCpxienHxlfDLczh-yS-Yyw=s1360-w1360-h1020-rw',
      is24Hours: true,
      phoneNumber: '+20-55-230-1000',
      specialty: 'University/Multi-Specialty',
      description:
          'Provides extensive medical care and training facilities, playing a vital role in health services for the Sharqia region.',
    ),

    HospitalModel(
      id: 'MNF001',
      name: 'Shebin El Kom Teaching Hospital',
      locationAddress: 'Shebin El Kom, Monufia',
      imagePath:
          'https://lh3.googleusercontent.com/gps-cs-s/AG0ilSykhdMWnxE7hycqXfxruySI3FGONwj--IV7N9fV-9lgfhr9oGpzL8saJUX_J3VNJiCLBz1eKjf07JLnNoIJmw65HNuRrCH5RO7mDmHQltbLxXkI7aAxgNxjB1KCjSz6-UEkZFLx=s1360-w1360-h1020-rw',
      openingTime: '08:00 AM',
      is24Hours: true,
      phoneNumber: '+20-48-232-2000',
      specialty: 'General/Teaching',
      description:
          'A major government hospital in Monufia, offering subsidized healthcare services and serving as a key training center for medical staff.',
    ),

    HospitalModel(
      id: 'GHR001',
      name: 'Tanta University Hospital',
      locationAddress: 'Tanta, Gharbia',
      openingTime: '08:00 AM',
      imagePath:
          'https://view.tanta.edu.eg/univ/7255b3cb-5be4-45ba-a257-1e32a028dddb%D8%A7%D9%84%D9%83%D9%84%D9%89.jpg',
      is24Hours: true,
      phoneNumber: '+20-40-333-3500',
      specialty: 'University/Multi-Specialty',
      description:
          'A large university complex serving the Delta region, renowned for its diverse medical specialties and emergency care capabilities.',
    ),

    HospitalModel(
      id: 'KFS001',
      name: 'Kafr El Sheikh University Hospital',
      locationAddress: 'Kafr El Sheikh',
      openingTime: '08:00 AM',
      imagePath:
          'https://lh3.googleusercontent.com/p/AF1QipMdCouqZePEFbnu69V5XnQvDs_UL-XFDzq0L81R=s1360-w1360-h1020-rw',
      is24Hours: true,
      phoneNumber: '+20-47-323-4000',
      specialty: 'University/Multi-Specialty',
      description:
          'Provides high-level medical services and is focused on expanding specialized care across the governorate.',
    ),

    HospitalModel(
      id: 'DMY001',
      name: 'New Damietta Specialized Hospital',
      locationAddress: 'New Damietta',
      imagePath:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS5_5agWBTIIvSo7lrg6amBkP7ETwCQS64zIw&s',
      openingTime: '08:00 AM',
      is24Hours: true,
      phoneNumber: '+20-57-240-5000',
      specialty: 'Specialized/General',
      description:
          'A modern facility designed to handle a variety of complex medical cases, enhancing healthcare access in the Damietta region.',
    ),

    HospitalModel(
      id: 'PSD001',
      name: 'Port Said General Hospital',
      locationAddress: 'Port Said',
      imagePath:
          'https://tolbagroup.com.eg/wp-content/uploads/2022/06/hospital-facade.jpg',
      openingTime: '08:00 AM',
      is24Hours: true,
      phoneNumber: '+20-66-324-6000',
      specialty: 'General/Military',
      description:
          'A key government healthcare facility serving Port Said and the surrounding area, with a strong focus on general surgery and internal medicine.',
    ),

    HospitalModel(
      id: 'ISM001',
      name: 'Suez Canal University Hospital',
      locationAddress: 'Ismailia',
      imagePath:
          'https://lh3.googleusercontent.com/gps-cs-s/AG0ilSyddhRoTqxTXTfM50nDfL13kaVuvD783PiV_FpsM5ZJWvhzpI5tREm5rg1616VIkZDPvJc79RRC3aIe26xAlXiQXTh15mUI0rqhYzsDxlbFCu7-0XKcMestppL0QAMjOx0RFC5Tog=s1360-w1360-h1020-rw',
      openingTime: '08:00 AM',
      is24Hours: true,
      phoneNumber: '+20-64-323-7000',
      specialty: 'University/Multi-Specialty',
      description:
          'The main university teaching hospital in the Suez Canal region, known for its academic and research contributions alongside patient care.',
    ),

    HospitalModel(
      id: 'SUZ001',
      name: 'Suez General Hospital',
      locationAddress: 'Suez',
      imagePath:
          'https://lh3.googleusercontent.com/gps-cs-s/AG0ilSxmICzYppgdJcOWqgVdgzNjWGEpx8OALRaOPEBfEhSTYMZrXaqq9ZZEcrPvEMiKB9LEkMBMRpGqhnB-Y53WNsD3IGnTyBUeBbVVOTTHpq1AcsEiHDHDNp5AYmwWvgCOq_0X-2KRPQ=s1360-w1360-h1020-rw',
      openingTime: '08:00 AM',
      is24Hours: true,
      phoneNumber: '+20-62-333-8000',
      specialty: 'General/Multi-Specialty',
      description:
          'A general hospital offering comprehensive services to the Suez governorate, playing a crucial role in regional public health.',
    ),

    HospitalModel(
      id: 'FYM001',
      name: 'Fayoum University Hospital',
      imagePath:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSt5ibmceF_C1tdLYwBgvZE7jP5yRNA2Ws40A&s',
      locationAddress: 'Fayoum',
      openingTime: '08:00 AM',
      is24Hours: true,
      phoneNumber: '+20-84-637-9000',
      specialty: 'University/Multi-Specialty',
      description:
          'Affiliated with Fayoum University, this hospital is a primary source of specialized medical treatment and clinical education in the area.',
    ),

    HospitalModel(
      id: 'BSF001',
      name: 'Beni Suef General Hospital',
      locationAddress: 'Beni Suef',
      imagePath: 'https://cegman.com/wp-content/uploads/2020/05/1.jpg',
      openingTime: '08:00 AM',
      is24Hours: true,
      phoneNumber: '+20-82-232-1000',
      specialty: 'General/Multi-Specialty',
      description:
          'A key regional hospital providing general medical services, emergency care, and essential health programs for the Beni Suef community.',
    ),

    HospitalModel(
      id: 'MNY001',
      name: 'Minya University Hospital',
      locationAddress: 'Minya',
      openingTime: '08:00 AM',
      imagePath:
          'https://lh3.googleusercontent.com/gps-cs-s/AG0ilSxeVg1kFSXC9WnKYn6vK69ZFgfYR03CZooWIcophoc1RsiYelOYaL6x53TPc2T6co-XZTcO2OF71y22Qr1hB7gM78hGOVgv_iPFCBOUD7oR5k_LDmsw6tEAdCT5kccVrx86qShF=s1360-w1360-h1020-rw',
      is24Hours: true,
      phoneNumber: '+20-86-236-2000',
      specialty: 'University/Multi-Specialty',
      description:
          'The largest healthcare provider in Upper Egypt\'s Minya governorate, known for its specialist units and teaching facilities.',
    ),

    HospitalModel(
      id: 'AST001',
      name: 'Asyut University Hospital',
      locationAddress: 'Asyut',
      imagePath:
          'https://lh3.googleusercontent.com/gps-cs-s/AG0ilSybJxQ5QyMTSrK_NdEpeLpdgn9ifbMkM0w4NUugsg0vMxaIpZSSsoz5TG5wHurrmVJA4BR5DQB8vmpZUgzF43IpOccTufSgwzPydBfS-68BzwRtRIl4FNC0miR0SCRxI7arpME=s1360-w1360-h1020-rw',
      openingTime: '08:00 AM',
      is24Hours: true,
      phoneNumber: '+20-88-233-3000',
      specialty: 'University/Multi-Specialty',
      description:
          'One of the oldest and most prominent university hospitals in Upper Egypt, serving a wide geographical area with highly specialized care.',
    ),

    HospitalModel(
      id: 'SOH001',
      name: 'Sohag University Hospital',
      locationAddress: 'Sohag',
      openingTime: '08:00 AM',
      imagePath:
          'https://www.sohag-univ.edu.eg/ar/wp-content/uploads/2023/03/337372025_1895196817482692_4573249402285324664_n-1024x682.jpg',
      is24Hours: true,
      phoneNumber: '+20-93-460-4000',
      specialty: 'University/Multi-Specialty',
      description:
          'Dedicated to medical education and providing tertiary care, supporting the healthcare needs of the Sohag population.',
    ),

    HospitalModel(
      id: 'QNA001',
      name: 'Qena University Hospital',
      locationAddress: 'Qena',
      openingTime: '08:00 AM',
      imagePath:
          'https://images.healtheg.com//Images/3026/61035845_2059010940874542_5132005556692713472_nbb835a8b-5215-4c09-a362-de400ecef3de.jpg',
      is24Hours: true,
      phoneNumber: '+20-96-321-5000',
      specialty: 'University/Multi-Specialty',
      description:
          'A key medical center in Qena, offering comprehensive inpatient and outpatient services alongside medical training programs.',
    ),

    HospitalModel(
      id: 'LXR001',
      name: 'Luxor International Hospital',
      locationAddress: 'Luxor',
      openingTime: '08:00 AM',
      imagePath:
          'https://lh3.googleusercontent.com/gps-cs-s/AG0ilSw5IvLGpR6m0BAoFcZUN4TbIvyFqUx2jwbf9no0VzwkQ3zzxf2aDbTY-k0E4Ik3MqfP2VjrcjreW_MG7tZJkKyyMJo7Y62hw8J6XhEQAWepO0tdRWXJtoKc_GVoTwcDtL9_zzjD=s1360-w1360-h1020-rw',
      is24Hours: true,
      phoneNumber: '+20-95-237-6000',
      specialty: 'International/Multi-Specialty',
      description:
          'A modern hospital offering specialized care, often catering to both local residents and international tourists in the Luxor area.',
    ),

    HospitalModel(
      id: 'ASW001',
      name: 'Aswan University Hospital',
      locationAddress: 'Aswan',
      openingTime: '08:00 AM',
      imagePath:
          'https://lh3.googleusercontent.com/gps-cs-s/AG0ilSw0_rRy5CTcKrhvYxPKPniGWOGmM38aB6lw98Mdh_SZlcWfF7Da8PxNLn-jtVnQ_JoWY7S-SvGWLr2AyYj_n-4363WaviAllOpW9ycQl0fuuyXHuW6QRWiMN8H3e2q6ENbhMsAK=s1360-w1360-h1020-rw',
      is24Hours: true,
      phoneNumber: '+20-97-230-7000',
      specialty: 'University/Multi-Specialty',
      description:
          'The primary teaching hospital in Aswan, focused on providing specialized healthcare and medical education for the southern region of Egypt.',
    ),

    HospitalModel(
      id: 'RSC001',
      name: 'Hurghada General Hospital',
      locationAddress: 'Hurghada',
      openingTime: '08:00 AM',
      imagePath:
          'https://images.healtheg.com//Images/2667/19_2021-637642164909981186-9989ac3f367-8e20-4bd3-93fc-0f850a8cfb84.jpeg',
      is24Hours: true,
      phoneNumber: '+20-65-344-8000',
      specialty: 'General/Tourism',
      description:
          'A major public hospital in the Red Sea region, equipped to handle emergencies and general medical needs for residents and visitors.',
    ),

    HospitalModel(
      id: 'NVL001',
      name: 'Al Kharga General Hospital',
      locationAddress: 'Al Kharga',
      openingTime: '08:00 AM',
      imagePath:
          'https://media.elwatannews.com/media/img/mediaarc/large/20721675551475743052.jpg',
      is24Hours: true,
      phoneNumber: '+20-92-792-9000',
      specialty: 'General',
      description:
          'Serving the remote New Valley governorate, this hospital provides essential health services to the communities in the Western Desert.',
    ),

    HospitalModel(
      id: 'MTR001',
      name: 'Marsa Matrouh General Hospital',
      locationAddress: 'Marsa Matrouh',
      imagePath:
          'https://lh3.googleusercontent.com/gps-cs-s/AG0ilSx3D8jF12_MsXRXYa65OhkCU9xzYDSi0fUgqH2uOW1lH_j4azKXO6KX50tvBrCx6_Bk3pwTLeBlgSC7s2kpaoEiRj2fheGzg_yw6tJa07hGMVVVY8b5Q2VigFsE43zTHOa8B7F1Rw=s1360-w1360-h1020-rw',
      openingTime: '08:00 AM',
      is24Hours: true,
      phoneNumber: '+20-46-493-1000',
      specialty: 'General/Tourism',
      description:
          'A key healthcare facility for the coastal city of Marsa Matrouh, especially busy during the summer tourism season.',
    ),

    HospitalModel(
      id: 'NSI001',
      name: 'Arish General Hospital',
      locationAddress: 'Arish',
      openingTime: '08:00 AM',
      imagePath:
          'https://lh3.googleusercontent.com/gps-cs-s/AG0ilSzN17RLFwU42K5EppPxIjkEWZsnkGuAEQY9ZGr1vtOTj3tKI92-F6Re6M_SJfEAQU_vbyH_bDNZPrdgE6aY2SBsJpWe5ysd-fR3sc5b0wSaz8mLhdcpI6VNCgP3DQ9n59bAe5Ic=s1360-w1360-h1020-rw',
      is24Hours: true,
      phoneNumber: '+20-68-333-2000',
      specialty: 'General',
      description:
          'The main general hospital in Arish, providing crucial medical and surgical services in the challenging North Sinai region.',
    ),

    HospitalModel(
      id: 'SSI001',
      name: 'Sharm El Sheikh International Hospital',
      locationAddress: 'Sharm El Sheikh',
      imagePath:
          'https://images.dailynewsegypt.com/2024/06/%D9%85%D8%B3%D8%AA%D8%B4%D9%81%D9%89_%D8%B4%D8%B1%D9%85_%D8%A7%D9%84%D8%B4%D9%8A%D8%AE.jpeg',
      openingTime: '08:00 AM',
      is24Hours: true,
      phoneNumber: '+20-69-366-3000',
      specialty: 'International/Tourism',
      description:
          'A high-standard facility often catering to the specialized needs of tourists and residents in the popular resort city.',
    ),

    HospitalModel(
      id: 'HLW001',
      name: 'Helwan General Hospital',
      locationAddress: 'Helwan, Cairo',
      openingTime: '08:00 AM',
      imagePath:
          'https://lh3.googleusercontent.com/gps-cs-s/AG0ilSwxc43sDbaiT6z0-8hmeZWLI-MWMsB-Wf3NUDZ3rBG8fXP43Ok4EMOEGTh5mR4eR5sOfG4ddYc0H8RBmbRN9Zehtq355Xx7w8MYKwI9BfLJUyUfZDDYLq_421ck_SQQrFGJX8n1og=s1360-w1360-h1020-rw',
      is24Hours: true,
      phoneNumber: '+20-22-556-4000',
      specialty: 'General',
      description:
          'Serving the southern districts of Cairo, offering general medicine and emergency services to a high-density urban area.',
    ),
  ];
}
