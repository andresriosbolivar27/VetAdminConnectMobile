import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vetadminconnectmobile/Model/Enums.dart';
import 'package:vetadminconnectmobile/Model/Pet.dart';

class EditPetPage extends StatefulWidget {
  final Pet pet;

  const EditPetPage({Key? key, required this.pet}) : super(key: key);

  @override
  State<EditPetPage> createState() => _EditPetPageState();
}

class _EditPetPageState extends State<EditPetPage> {
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late int _selectedGender;
  late int _selectedSpecie;
  late int _selectedBreed;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.pet.petName);
    _ageController = TextEditingController(text: widget.pet.petAge.toString());
    _selectedGender = widget.pet.petGenderType;
    _selectedSpecie = widget.pet.petSpecieId;
    _selectedBreed = widget.pet.petBreedId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar ${widget.pet.petName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre de la mascota',
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(
                labelText: 'Edad de la mascota',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20.0),
            DropdownButtonFormField<int>(
              value: _selectedGender,
              onChanged: (newValue) {
                setState(() {
                  _selectedGender = newValue!;
                });
              },
              items: [
                DropdownMenuItem<int>(
                  value: GenderType.male.index,
                  child: Text('Macho'),
                ),
                DropdownMenuItem<int>(
                  value: GenderType.female.index,
                  child: Text('Hembra'),
                ),
              ],
              decoration: InputDecoration(
                labelText: 'Género',
              ),
            ),
            const SizedBox(height: 20.0),
            DropdownButtonFormField<int>(
              value: _selectedSpecie,
              onChanged: (newValue) {
                setState(() {
                  _selectedSpecie = newValue!;
                });
              },
              items: [
              ],
              decoration: InputDecoration(
                labelText: 'Especie',
              ),
            ),
            const SizedBox(height: 20.0),
            DropdownButtonFormField<int>(
              value: _selectedBreed,
              onChanged: (newValue) {
                setState(() {
                  _selectedBreed = newValue!;
                });
              },
              items: [
                // Agregar elementos basados en las razas disponibles para la especie seleccionada
              ],
              decoration: InputDecoration(
                labelText: 'Raza',
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                widget.pet.petName = _nameController.text;
                widget.pet.petAge = int.parse(_ageController.text);
                widget.pet.petGenderType = _selectedGender;
                widget.pet.petSpecieId = _selectedSpecie;
                widget.pet.petBreedId = _selectedBreed;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Mascota actualizada: ${widget.pet.petName}'),
                  ),
                );
                Navigator.pop(context);
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
