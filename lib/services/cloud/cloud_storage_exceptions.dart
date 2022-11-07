class CloudStorageException implements Exception {
  const CloudStorageException();
}

// create
class CouldNotCreateNoteException extends CloudStorageException {}

// read
class CouldNotGetAllNotesException extends CloudStorageException {}

// update
class CouldNotUpdateNoteExeption extends CloudStorageException {}

//delete
class CouldNotDeleteNoteException extends CloudStorageException {}
