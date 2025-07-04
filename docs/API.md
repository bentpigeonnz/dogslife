# dogsLife API Reference

## User Service

- `UserService.getUser(uid)`
- `UserService.updateProfile(data)`

## Dog Service

- `DogService.getDogById(dogId)`
- `DogService.addDog(dog)`
- `DogService.updateDog(dog)`
- `DogService.deleteDog(dogId)`
- `DogService.listDogs()`

## Event Service

- `EventService.getEventById(eventId)`
- `EventService.addEvent(event)`
- `EventService.updateEvent(event)`
- `EventService.deleteEvent(eventId)`

## Image Service

- `ImageService.uploadDogImage(file, {dogId, onProgress})`
- `ImageService.deleteImageByUrl(url)`

## More: See `/services/` directory and Dartdoc for full list.
