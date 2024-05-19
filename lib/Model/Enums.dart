enum UserType
{
  admin,
  client,
  vet,
  anonymous
}

enum GenderType
{
  female,
  male
}

enum SizeType
{
  small,
  medium,
  large
}
enum SeverityException
{
Error,
Warning,
Information
}

final Map<GenderType, String> genderTypeTranslations = {
  GenderType.male: 'Macho',
  GenderType.female: 'Hembra',
};

// Mapa de traducción
final Map<SizeType, String> sizeTypeTranslations = {
  SizeType.small: 'Pequeño',
  SizeType.medium: 'Mediano',
  SizeType.large: 'Grande',
};