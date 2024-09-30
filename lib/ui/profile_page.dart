import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qtim/models/profile_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isEdit = false;
  final _formKey = GlobalKey<FormState>();

  // изначальные данные профиля пользователя
  Profile profile = Profile(
      name: "Иван Иванов",
      email: "ivan@example.com",
      phone: "+7 999 123 4567",
      avatars: [
        Avatar(path: "https://via.placeholder.com/150", isLocal: false),
        Avatar(path: "https://via.placeholder.com/150", isLocal: false),
        Avatar(path: "https://via.placeholder.com/150", isLocal: false),
      ]
  );

  Future<void> _pickAvatar() async {
    // загружаем фото с телефона
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        profile.avatars.add(Avatar(path: pickedFile.path, isLocal: true)); // Добавляем новую аватарку
      });
    }
  }

  void _updateUserInfo() {
    // сохранение изменения данных
    if(isEdit){
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Информация обновлена'),
        ));
        setState(() {
          isEdit = false;
        });
      }
    }else{
      setState(() {
        isEdit = true;
      });
    }
  }

  Widget viewText(String name, String value){
    // отображение текста
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: "$name: ",
            style: const TextStyle(fontSize: 16),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль пользователя'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(
                height: 150,
                child: profile.avatars.isNotEmpty ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: profile.avatars.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                        isEdit ? InkWell(
                          onTap: (){
                            // удаляем фото из профиля
                            setState(() {
                              profile.avatars.removeAt(index);
                            });
                          },
                          child: const Icon(Icons.highlight_remove_sharp),
                        ) : Container(),
                        profile.avatars[index].isLocal ? CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage(profile.avatars[index].path),
                        ) : CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(profile.avatars[index].path),
                        )
                      ],)
                    );
                  },
                  // если массив изображений пуст
                ) : const Center(
                  child: Icon(Icons.account_circle, size: 120, color: Colors.black54,),
                ),
              ),
              // добавление фото в профиль
              isEdit ? TextButton.icon(
                onPressed: _pickAvatar,
                icon: const Icon(Icons.add_a_photo),
                label: const Text('Добавить аватарку'),
              ) : Container(),
              const SizedBox(height: 20),
              isEdit ? TextFormField(
                initialValue: profile.name,
                decoration: const InputDecoration(labelText: 'Имя'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите имя';
                  }
                  return null;
                },
                onSaved: (value) {
                  profile.name = value!;
                },
              ) : viewText("Имя", profile.name),
              const SizedBox(height: 10),
              isEdit? TextFormField(
                initialValue: profile.email,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Введите корректный email';
                  }
                  return null;
                },
                onSaved: (value) {
                  profile.email = value!;
                },
              ) : viewText("Email", profile.email),
              const SizedBox(height: 10),
              isEdit ? TextFormField(
                initialValue: profile.phone,
                decoration: const InputDecoration(labelText: 'Телефон'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите телефон';
                  }
                  return null;
                },
                onSaved: (value) {
                  profile.phone = value!;
                },
              ) : viewText("Телефон", profile.phone),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateUserInfo,
                child: Text(isEdit ? 'Сохранить' : 'Редактировать'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
