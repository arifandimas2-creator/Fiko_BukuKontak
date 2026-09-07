import 'package:flutter/material.dart';

void main() {
  runApp(const BukuKontakApp());
}

// 1. Class Kontak dengan properti kategori bertipe nullable (String?)
class Kontak {
  String nama;
  String nomor;
  String? kategori; // Properti nullable

  // 2. Constructor dengan kategori opsional
  Kontak({
    required this.nama,
    required this.nomor,
    this.kategori, // Opsional (tidak wajib diisi)
  });
}

class BukuKontakApp extends StatelessWidget {
  const BukuKontakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buku Kontak',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // List untuk menyimpan data kontak
  final List<Kontak> _kontakList = [];

  // Controller untuk mengambil input dari Form
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nomorController = TextEditingController();
  final TextEditingController _kategoriController = TextEditingController();

  // Fungsi untuk menambah kontak baru
  void _tambahKontak() {
    final String nama = _namaController.text.trim();
    final String nomor = _nomorController.text.trim();
    final String kategoriInput = _kategoriController.text.trim();

    if (nama.isNotEmpty && nomor.isNotEmpty) {
      setState(() {
        _kontakList.add(
          Kontak(
            nama: nama,
            nomor: nomor,
            // Jika input kategori kosong, simpan sebagai null
            kategori: kategoriInput.isEmpty ? null : kategoriInput,
          ),
        );
      });

      // Bersihkan inputan
      _namaController.clear();
      _nomorController.clear();
      _kategoriController.clear();

      // Tutup modal
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kontak berhasil ditambahkan!')),
      );
    }
  }

  // 3. Form Tambah Kontak dengan Input Kategori
  void _showFormTambah() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Tambah Kontak Baru',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _nomorController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Nomor Telepon',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
              ),
              const SizedBox(height: 10),
              // Input Tambahan untuk Kategori
              TextField(
                controller: _kategoriController,
                decoration: const InputDecoration(
                  labelText: 'Kategori (Opsional: Keluarga, Teman, Kerja)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: _tambahKontak,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(45),
                ),
                child: const Text('Simpan'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Kontak'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _kontakList.isEmpty
          ? const Center(
              child: Text(
                'Belum ada kontak.\nKlik tombol + untuk menambah.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: _kontakList.length,
              itemBuilder: (context, index) {
                final kontak = _kontakList[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      kontak.nama.isNotEmpty ? kontak.nama[0].toUpperCase() : '?',
                    ),
                  ),
                  title: Text(kontak.nama),
                  // 4. Menggunakan null-aware operator (??) untuk menampilkan 'Tanpa kategori'
                  subtitle: Text(
                    '${kontak.nomor} • ${kontak.kategori ?? 'Tanpa kategori'}',
                  ),
                  trailing: const Icon(Icons.call, color: Colors.teal),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showFormTambah,
        child: const Icon(Icons.add),
      ),
    );
  }
}