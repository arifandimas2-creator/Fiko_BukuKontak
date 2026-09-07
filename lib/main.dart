import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Buku Kontak',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const BerandaPage(),
    );
  }
}

// TUGAS 4: Properti kategori bertipe String? (Nullable)
class Kontak {
  final String nama;
  final String email;
  final String noHp;
  final String? kategori; // Opsional/Nullable

  Kontak({
    required this.nama,
    required this.email,
    required this.noHp,
    this.kategori,
  });
}

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  final List<Kontak> _daftarKontak = [];

  final List<Kontak> _daftarFavorit = [
    Kontak(
      nama: "Mu'ammar Akyas",
      email: "akyas136@gmail.com",
      noHp: "085641343755",
      kategori: "Teman",
    ),
  ];

  // TUGAS 6: StreamController untuk pencarian real-time
  final StreamController<String> _searchController =
      StreamController<String>.broadcast();

  @override
  void dispose() {
    _searchController.close(); // Mencegah memory leak
    super.dispose();
  }

  void _navigasiKeTambahKontak() async {
    final Kontak? kontakBaru = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TambahKontakPage()),
    );

    if (kontakBaru != null) {
      setState(() {
        _daftarKontak.add(kontakBaru);
      });
    }
  }

  void _navigasiKeTentang() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TentangPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('BUKU KONTAK'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.purpleAccent,
            tabs: [
              Tab(icon: Icon(Icons.account_circle), text: 'Kontak'),
              Tab(icon: Icon(Icons.star), text: 'Favorit'),
            ],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Text(
                  'BUKU KONTAK',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.account_box),
                title: const Text('Kontak'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.add),
                title: const Text('Tambah Kontak'),
                onTap: () {
                  Navigator.pop(context);
                  _navigasiKeTambahKontak();
                },
              ),
              ListTile(
                leading: const Icon(Icons.star),
                title: const Text('Favorit'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('Tentang'),
                onTap: _navigasiKeTentang,
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // TAB 1: Daftar Kontak + Pencarian Stream (TUGAS 6)
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Cari Kontak (Nama / Kategori)',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (text) {
                      _searchController.add(text); // Masukkan input ke stream
                    },
                  ),
                ),
                Expanded(
                  child: StreamBuilder<String>(
                    stream: _searchController.stream,
                    initialData: '',
                    builder: (context, snapshot) {
                      final query = snapshot.data?.toLowerCase() ?? '';

                      // Filter nama atau kategori (case-insensitive)
                      final filteredList = _daftarKontak.where((kontak) {
                        final namaMatch =
                            kontak.nama.toLowerCase().contains(query);
                        final kategoriMatch = (kontak.kategori ?? '')
                            .toLowerCase()
                            .contains(query);
                        return namaMatch || kategoriMatch;
                      }).toList();

                      if (filteredList.isEmpty) {
                        return const Center(
                            child: Text('Tidak ada kontak ditemukan'));
                      }

                      return ListView.builder(
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          final item = filteredList[index];
                          return ListTile(
                            // TUGAS 3: CircleAvatar inisial huruf pertama
                            leading: CircleAvatar(
                              child: Text(
                                item.nama.isNotEmpty
                                    ? item.nama[0].toUpperCase()
                                    : '?',
                              ),
                            ),
                            title: Text(item.nama),
                            // TUGAS 4: Null-aware operator (??) untuk kategori
                            subtitle: Text(
                              '${item.email}\n${item.noHp} - Kategori: ${item.kategori ?? 'Tanpa kategori'}',
                            ),
                            isThreeLine: true,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),

            // TAB 2: Daftar Favorit
            _daftarFavorit.isEmpty
                ? const Center(child: Text('Belum ada kontak favorit'))
                : ListView.builder(
                    itemCount: _daftarFavorit.length,
                    itemBuilder: (context, index) {
                      final item = _daftarFavorit[index];
                      return ListTile(
                        // TUGAS 3: CircleAvatar inisial
                        leading: CircleAvatar(
                          child: Text(
                            item.nama.isNotEmpty
                                ? item.nama[0].toUpperCase()
                                : '?',
                          ),
                        ),
                        title: Text(item.nama),
                        subtitle: Text(
                          '${item.email}\n${item.noHp} - Kategori: ${item.kategori ?? 'Tanpa kategori'}',
                        ),
                        isThreeLine: true,
                      );
                    },
                  ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _navigasiKeTambahKontak,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class TambahKontakPage extends StatefulWidget {
  const TambahKontakPage({super.key});

  @override
  State<TambahKontakPage> createState() => _TambahKontakPageState();
}

class _TambahKontakPageState extends State<TambahKontakPage> {
  // TUGAS 5: Key untuk validasi form
  final _formKey = GlobalKey<FormState>();

  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _hpController = TextEditingController();
  final _kategoriController = TextEditingController();

  void _simpan() {
    // TUGAS 5: Eksekusi simpan hanya jika validasi sukses
    if (_formKey.currentState!.validate()) {
      final kontakBaru = Kontak(
        nama: _namaController.text,
        email: _emailController.text,
        noHp: _hpController.text,
        kategori: _kategoriController.text.trim().isEmpty
            ? null
            : _kategoriController.text,
      );
      Navigator.pop(context, kontakBaru);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Kontak'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // TUGAS 5: Widget Form
          child: ListView(
            children: [
              // TUGAS 5: TextFormField + Validator Nama
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              // TUGAS 5: TextFormField + Validator Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email wajib diisi';
                  }
                  if (!value.contains('@')) {
                    return 'Email harus mengandung karakter @';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              // TUGAS 5: TextFormField + Validator No HP
              TextFormField(
                controller: _hpController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'No Handphone'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'No Handphone wajib diisi';
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'No Handphone hanya boleh angka';
                  }
                  if (value.length < 10) {
                    return 'No Handphone minimal 10 digit';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              // TUGAS 4: Field Kategori (Opsional, tanpa validator)
              TextFormField(
                controller: _kategoriController,
                decoration: const InputDecoration(
                  labelText: 'Kategori (Opsional, contoh: Teman/Keluarga)',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _simpan,
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TentangPage extends StatelessWidget {
  const TentangPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentang'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/profile.jpg'),
            ),
            SizedBox(height: 15),
            Text(
              'Fiko Dafa',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text('XII PPLG / RPL'),
            SizedBox(height: 5),
            Text('SMK Negeri 5 Surakarta'),
          ],
        ),
      ),
    );
  }
}