class ResultModel {
  final String disease;
  final String description;
  final String symptom;
  final String medicalAdvice;

  ResultModel(this.disease, this.description, this.symptom, this.medicalAdvice);
}

final String disease = "Cataract";
final String Cdescription =
    "Cataract is a clouding of the normally clear lens of your eye. For people who have cataracts, seeing through cloudy lenses is a bit like looking through a frosty or fogged-up window. Clouded vision caused by cataracts can make it more difficult to read, drive a car (especially at night) or see the expression on a friend's face.";
final String Gdescription =
    "Glaucoma is a group of eye diseases that can cause vision loss and blindness by damaging a nerve in the back of your eye called the optic nerve. This nerve acts like an electric cable with over a million wires. It is responsible for carrying images from the eye to the brain.";
final String Gsymptom =
    "Glaucoma is a group of eye diseases that can cause vision loss and blindness by damaging a nerve in the back of your eye called the optic nerve. This nerve acts like an electric cable with over a million wires. It is responsible for carrying images from the eye to the brain.";
final String GmedicalAdvice =
    "Glaucoma is a group of eye diseases that can cause vision loss and blindness by damaging a nerve in the back of your eye called the optic nerve. This nerve acts like an electric cable with over a million wires. It is responsible for carrying images from the eye to the brain.";

ResultModel glaucomaResult =
    new ResultModel("Glaucoma", Gdescription, Gsymptom, GmedicalAdvice);
ResultModel cataractResult =
    new ResultModel("Cataract", Cdescription, Gsymptom, GmedicalAdvice);
