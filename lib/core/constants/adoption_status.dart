enum AdoptionStatus {
  available,
  pending,
  adopted,
  archived,
}

const Map<AdoptionStatus, String> kAdoptionStatusLabels = {
  AdoptionStatus.available: 'Available',
  AdoptionStatus.pending: 'Pending',
  AdoptionStatus.adopted: 'Adopted',
  AdoptionStatus.archived: 'Archived',
};
