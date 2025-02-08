import 'package:flutter/material.dart';
import '/controllers/authroutes.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  List<dynamic> users = [];
  bool isLoading = true; // Estado de carga

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      final authRoutes = AuthRoutes();
      final fetchedUsers = await authRoutes.listarUsuarios();
      setState(() {
        users = fetchedUsers;
        isLoading = false;
      });
    } catch (e) {
      //print('Error al obtener usuarios: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _deleteUser(int index) {
    setState(() {
      users.removeAt(index);
    });
  }

  void _showAddUserDialog() {
    TextEditingController usuarioController = TextEditingController();
    TextEditingController nombreController = TextEditingController();
    TextEditingController correoController = TextEditingController();
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
                controller: correoController,
                decoration: InputDecoration(labelText: 'Correo'),
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
              //cuando se presiona el botón de agregar se mandan los datos a la función crearUsuario de AuthRoutes
              onPressed: () async {
                // al presionar el botón de agregar se manda la información a la función crearUsuario de AuthRoutes
                final authRoutes = AuthRoutes();
                await authRoutes.crearUsuario({
                  'usuario': usuarioController.text,
                  'nombre': nombreController.text,
                  'correo': correoController.text,
                  'rol': rolController.text,
                  'password': passwordController.text,
                });
                // ignore: use_build_context_synchronously
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
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Muestra loading mientras se cargan los datos
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Text(users[index]['nombre'] ?? 'Sin nombre'),
                            subtitle: Text('Usuario: ${users[index]['usuario']} - Rol: ${users[index]['rol']} - Correo: ${users[index]['correo']}'),
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
