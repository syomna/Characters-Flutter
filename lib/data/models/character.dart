class Character {
   String? id;
   String? name;
   List<String>? alternateNames;
   String? species;
   String? gender;
   String? house;
   String? dateOfBirth;
   int? yearOfBirth;
   bool? wizard;
   String? ancestry;
   String? eyeColour;
   String? hairColour;
   String? patronus;
   bool? hogwartsStudent;
   bool? hogwartsStaff;
   String? actor;
   bool? alive;
   String? image;

  Character.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    alternateNames = json['alternate_names'].cast<String>();
    species = json['species'];
    gender = json['gender'];
    house = json['house'];
    dateOfBirth = json['dateOfBirth'];
    yearOfBirth = json['yearOfBirth'];
    wizard = json['wizard'];
    ancestry = json['ancestry'];
    eyeColour = json['eyeColour'];
    hairColour = json['hairColour'];
    patronus = json['patronus'];
    hogwartsStudent = json['hogwartsStudent'];
    hogwartsStaff = json['hogwartsStaff'];
    actor = json['actor'];
    alive = json['alive'];
    image = json['image'];
  }
}
