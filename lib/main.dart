import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:audioplayers/audioplayers.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Caja de Herramientas',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: SafeArea(child: HomePage()),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth = screenWidth > 400 ? 360.0 : screenWidth * 0.92;
    final iconSize = screenWidth > 400 ? 90.0 : screenWidth * 0.22;
    return Scaffold(
      backgroundColor: Color(0xFFFAF5F5),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: containerWidth,
                  padding: EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                  decoration: BoxDecoration(
                    color: Color(0xFFBCAAA4),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'ToolBox',
                      style: TextStyle(
                        fontFamily: 'Comic Sans MS',
                        fontSize: 38,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
                // Toolbox icon
                Container(
                  width: containerWidth,
                  padding: EdgeInsets.symmetric(vertical: 32),
                  color: Color(0xFFFAF5F5),
                  child: Icon(
                    Icons.work,
                    size: iconSize,
                    color: Colors.grey[800],
                  ),
                ),
                // Buttons in a more organized grid
                Container(
                  width: containerWidth,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(vertical: 24, horizontal: 18),
                  child: Column(
                    children: [
                      _HomeButton(
                        text: 'Predecir Género',
                        icon: Icons.male,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GenderPredictorPage(),
                          ),
                        ),
                      ),
                      _HomeButton(
                        text: 'Predecir Edad',
                        icon: Icons.cake,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AgePredictorPage(),
                          ),
                        ),
                      ),
                      _HomeButton(
                        text: 'Buscar Universidades',
                        icon: Icons.school,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UniversitySearchPage(),
                          ),
                        ),
                      ),
                      _HomeButton(
                        text: 'Ver Clima en RD',
                        icon: Icons.cloud,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WeatherPage(),
                          ),
                        ),
                      ),
                      _HomeButton(
                        text: 'Buscar Pokémon',
                        icon: Icons.catching_pokemon,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PokemonInfoPage(),
                          ),
                        ),
                      ),
                      _HomeButton(
                        text: 'Ver Noticias de TechCrunch',
                        icon: Icons.newspaper,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TechCrunchNewsPage(),
                          ),
                        ),
                      ),
                      _HomeButton(
                        text: 'Contacto',
                        icon: Icons.person,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AcercaDePage(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;
  const _HomeButton({
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 48),
          backgroundColor: Color(0xFFBCAAA4),
          foregroundColor: Colors.black,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        icon: Icon(icon, size: 26),
        label: Text(
          text,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        onPressed: onTap,
      ),
    );
  }
}

// ------------------ PREDICTOR DE GÉNERO ------------------
class GenderPredictorPage extends StatefulWidget {
  const GenderPredictorPage({super.key});

  @override
  _GenderPredictorPageState createState() => _GenderPredictorPageState();
}

class _GenderPredictorPageState extends State<GenderPredictorPage> {
  final TextEditingController _controller = TextEditingController();
  String? gender;
  bool loading = false;

  Future<void> predictGender(String name) async {
    setState(() {
      loading = true;
      gender = null;
    });

    final url = Uri.parse('https://api.genderize.io/?name=$name');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        gender = data['gender'];
        loading = false;
      });
    } else {
      setState(() {
        gender = null;
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.white;
    if (gender == 'male') backgroundColor = Colors.blue[100]!;
    if (gender == 'female') backgroundColor = Colors.pink[100]!;

    return Scaffold(
      appBar: AppBar(title: Text('Predecir Género')),
      body: SafeArea(
        child: Container(
          color: backgroundColor,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Ingresa tu nombre',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: loading
                    ? null
                    : () => predictGender(_controller.text.trim()),
                child: Text('Predecir Género'),
              ),
              SizedBox(height: 20),
              if (loading) CircularProgressIndicator(),
              if (gender != null && !loading)
                Text(
                  'Género detectado: ${gender == "male" ? "Masculino" : "Femenino"}',
                  style: TextStyle(fontSize: 22),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------ PREDICTOR DE EDAD ------------------
class AgePredictorPage extends StatefulWidget {
  const AgePredictorPage({super.key});

  @override
  _AgePredictorPageState createState() => _AgePredictorPageState();
}

class _AgePredictorPageState extends State<AgePredictorPage> {
  final TextEditingController _controller = TextEditingController();
  int? age;
  String? category;
  String? imageUrl;
  bool loading = false;

  Future<void> predictAge(String name) async {
    setState(() {
      loading = true;
      age = null;
      category = null;
      imageUrl = null;
    });

    final url = Uri.parse('https://api.agify.io/?name=$name');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final predictedAge = data['age'];

      String tempCategory;
      String tempImage;
      if (predictedAge < 18) {
        tempCategory = 'Joven';
        tempImage = 'https://cdn-icons-png.flaticon.com/512/201/201634.png';
      } else if (predictedAge < 60) {
        tempCategory = 'Adulto';
        tempImage = 'https://cdn-icons-png.flaticon.com/512/236/236831.png';
      } else {
        tempCategory = 'Anciano';
        tempImage = 'https://cdn-icons-png.flaticon.com/512/4140/4140048.png';
      }

      setState(() {
        age = predictedAge;
        category = tempCategory;
        imageUrl = tempImage;
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
        age = null;
        category = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Predecir Edad')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Ingresa tu nombre',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: loading
                    ? null
                    : () => predictAge(_controller.text.trim()),
                child: Text('Predecir Edad'),
              ),
              SizedBox(height: 20),
              if (loading) CircularProgressIndicator(),
              if (age != null && category != null && !loading) ...[
                Text(
                  'Edad estimada: $age años',
                  style: TextStyle(fontSize: 22),
                ),
                Text('Categoría: $category', style: TextStyle(fontSize: 20)),
                SizedBox(height: 10),
                if (imageUrl != null) Image.network(imageUrl!, height: 100),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------ BUSCADOR DE UNIVERSIDADES ------------------
class UniversitySearchPage extends StatefulWidget {
  const UniversitySearchPage({super.key});

  @override
  _UniversitySearchPageState createState() => _UniversitySearchPageState();
}

class _UniversitySearchPageState extends State<UniversitySearchPage> {
  final TextEditingController _controller = TextEditingController();
  List universities = [];
  bool loading = false;

  Future<void> fetchUniversities(String country) async {
    setState(() {
      loading = true;
      universities = [];
    });

    final encodedCountry = Uri.encodeComponent(country.trim());
    final url = Uri.parse(
      'http://universities.hipolabs.com/search?country=$encodedCountry',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        universities = data;
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
        universities = [];
      });
    }
  }

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Buscar Universidades por País')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Nombre del país (en inglés)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: loading
                    ? null
                    : () => fetchUniversities(_controller.text),
                child: Text('Buscar'),
              ),
              SizedBox(height: 20),
              if (loading) CircularProgressIndicator(),
              if (!loading && universities.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: universities.length,
                    itemBuilder: (context, index) {
                      final uni = universities[index];
                      final webPage = (uni['web_pages'] as List).isNotEmpty
                          ? uni['web_pages'][0]
                          : 'No disponible';

                      return Card(
                        elevation: 3,
                        margin: EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          title: Text(uni['name']),
                          subtitle: Text('Dominio: ${uni['domains'][0]}'),
                          trailing: IconButton(
                            icon: Icon(Icons.link),
                            onPressed: webPage != 'No disponible'
                                ? () => _launchURL(webPage)
                                : null,
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------ VISTA DEL CLIMA EN RD ------------------
class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  String weather = '';
  bool loading = false;

  Future<void> fetchWeather() async {
    setState(() {
      loading = true;
    });

    try {
      final url = Uri.parse('https://wttr.in/SantoDomingo?format=3');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          weather = response.body;
          loading = false;
        });
      } else {
        setState(() {
          weather = 'Error al obtener el clima';
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        weather = 'Error de conexión';
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWeather(); // se llama automáticamente al abrir la vista
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Clima en República Dominicana')),
      body: SafeArea(
        child: Center(
          child: loading
              ? CircularProgressIndicator()
              : Text(
                  weather,
                  style: TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
        ),
      ),
    );
  }
}

// ------------------ VISTA DE POKÉMON ------------------
class PokemonInfoPage extends StatefulWidget {
  const PokemonInfoPage({super.key});

  @override
  _PokemonInfoPageState createState() => _PokemonInfoPageState();
}

class _PokemonInfoPageState extends State<PokemonInfoPage> {
  final TextEditingController _controller = TextEditingController();
  String? imageUrl;
  int? baseExperience;
  List<String> abilities = [];
  String? cryUrl;
  bool loading = false;

  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> fetchPokemonInfo(String name) async {
    setState(() {
      loading = true;
      imageUrl = null;
      baseExperience = null;
      abilities = [];
      cryUrl = null;
    });

    final url = Uri.parse(
      'https://pokeapi.co/api/v2/pokemon/${name.toLowerCase()}',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final sprite = data['sprites']['front_default'];
      final experience = data['base_experience'];
      final abilityList = (data['abilities'] as List)
          .map<String>((item) => item['ability']['name'])
          .toList();

      final cry =
          'https://play.pokemonshowdown.com/audio/cries/${name.toLowerCase()}.mp3';

      setState(() {
        imageUrl = sprite;
        baseExperience = experience;
        abilities = abilityList;
        cryUrl = cry;
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Pokémon no encontrado')));
    }
  }

  void _playCry() {
    if (cryUrl != null) {
      _audioPlayer.play(UrlSource(cryUrl!));
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Buscar Pokémon')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Nombre del Pokémon (en inglés)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: loading
                    ? null
                    : () => fetchPokemonInfo(_controller.text.trim()),
                child: Text('Buscar'),
              ),
              SizedBox(height: 20),
              if (loading) CircularProgressIndicator(),
              if (imageUrl != null) Image.network(imageUrl!, height: 120),
              if (baseExperience != null)
                Text('Experiencia Base: $baseExperience'),
              if (abilities.isNotEmpty) ...[
                Text(
                  'Habilidades:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                for (var ability in abilities) Text('• $ability'),
              ],
              if (cryUrl != null)
                ElevatedButton.icon(
                  icon: Icon(Icons.volume_up),
                  label: Text('Reproducir sonido'),
                  onPressed: _playCry,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------ VISTA DE TECHCRUNCH ------------------
class TechCrunchNewsPage extends StatefulWidget {
  const TechCrunchNewsPage({super.key});

  @override
  _TechCrunchNewsPageState createState() => _TechCrunchNewsPageState();
}

class _TechCrunchNewsPageState extends State<TechCrunchNewsPage> {
  List<dynamic> news = [];
  bool loading = false;

  Future<void> fetchNews() async {
    setState(() {
      loading = true;
    });

    final url = Uri.parse(
      'https://techcrunch.com/wp-json/wp/v2/posts?per_page=3&_embed',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        news = json.decode(response.body);
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
        news = [];
      });
    }
  }

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Noticias TechCrunch')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'Noticias TechCrunch',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
              SizedBox(height: 20),
              if (loading)
                CircularProgressIndicator()
              else if (news.isEmpty)
                Text('No se pudieron cargar noticias.')
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: news.length,
                    itemBuilder: (context, index) {
                      final item = news[index];
                      final title = item['title']['rendered'];
                      final excerpt = item['excerpt']['rendered'].replaceAll(
                        RegExp(r'<[^>]*>'),
                        '',
                      ); // Limpiar HTML
                      final link = item['link'];

                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        elevation: 3,
                        child: ListTile(
                          title: Text(title),
                          subtitle: Text(excerpt),
                          trailing: Icon(Icons.open_in_new),
                          onTap: () => _launchURL(link),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------ VISTA DE CONTACTO ------------------
class AcercaDePage extends StatelessWidget {
  const AcercaDePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Acerca de mí')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/Foto.jpg'),
              ),
              SizedBox(height: 20),
              Text(
                'Walki Jr. Hughes Madrigal',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text('📧 Correo: walkijrhughesm2@gmail.com'),
              Text('📞 Teléfono: 809 893 9879'),
              SizedBox(height: 20),
              Text(
                'Desarrollador Flutter entusiasta. Disponible para trabajos freelance, colaboraciones y oportunidades laborales.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
