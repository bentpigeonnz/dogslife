import 'package:dogsLife/features/dogs/models/dog.dart';
import 'package:dogsLife/features/adoptions/models/adoption.dart';
import 'package:dogsLife/features/user_profiles/models/user_profile.dart';

final fakeDog = Dog(
  id: 'd1',
  name: 'MockDog',
  ageYears: 2,
  ageMonths: 3,
  gender: DogGender.male,
  breed: 'Husky',
  description: '',
  photoUrls: [],
  medicalStatus: 'Healthy',
  vaccinations: [],
  microchipNumber: '',
  microchipRegistry: '',
  adoptionStatus: AdoptionStatus.available,
  intakeDate: DateTime(2023, 1, 1),
);

final fakeAdoption = Adoption(
  id: 'a1',
  dogId: 'd1',
  applicantId: 'u1',
  status: 'pending',
  comments: 'Can\'t wait!',
  appliedAt: DateTime(2023, 2, 1),
);

final fakeUser = UserProfile(
  id: 'u1',
  email: 'mock@user.com',
  name: 'Mock User',
  photoUrl: '',
  phone: '021000000',
  address: 'Mock St',
  role: 'guest',
);
