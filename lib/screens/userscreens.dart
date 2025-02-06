import 'package:flutter/material.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  List<Map<String, String>> users = [
    {'usuario': 'admin', 'nombre': 'Administrador', 'rol': 'Admin'},
    {'usuario': 'user1', 'nombre': 'Usuario Uno', 'rol': 'Empleado'},
    {'usuario': 'user2', 'nombre': 'Usuario Dos', 'rol': 'Empleado'},
  ];

  void _deleteUser(int index) {
    setState(() {
      users.removeAt(index);
    });
  }

  void _showAddUserDialog() {
    TextEditingController usuarioController = TextEditingController();
    TextEditingController nombreController = TextEditingController();
    TextEditingController rolController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Agregar Usuario'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: usuarioController,
                decoration: InputDecoration(labelText: 'Usuario'),
              ),
              TextField(
                controller: nombreController,
                decoration: InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: rolController,
                decoration: InputDecoration(labelText: 'Rol'),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  users.add({
                    'usuario': usuarioController.text,
                    'nombre': nombreController.text,
                    'rol': rolController.text,
                  });
                });
                Navigator.pop(context);
              },
              child: Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión de Usuarios'),
        backgroundColor: Color(0xFF6F61EF),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(users[index]['nombre']!),
                      subtitle: Text('Usuario: ${users[index]['usuario']} - Rol: ${users[index]['rol']}'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteUser(index),
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _showAddUserDialog,
              child: Text('Agregar Usuario'),
            ),
          ],
        ),
      ),
    );
  }
}
