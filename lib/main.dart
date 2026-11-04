import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

const _ink = Color(0xFF3B2521);
const _paper = Color(0xFFFCF8F3);
const _henna = Color(0xFFA96A55);
const _contactSurface = Color(0xFFF2E6DE);
const _whatsAppGreen = Color(0xFF315C46);
const _muted = Color(0xFF806F67);

void main() {
  runApp(const MehndiApp());
}

class MehndiApp extends StatelessWidget {
  const MehndiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Henna Artistry | Mehndi Artist in Kochi & Kottayam',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: _paper,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _henna,
          surface: _paper,
          onSurface: _ink,
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: _ink,
          selectionColor: _henna,
        ),
      ),
      home: const MehndiHomePage(),
    );
  }
}

class MehndiHomePage extends StatefulWidget {
  const MehndiHomePage({super.key});

  @override
  State<MehndiHomePage> createState() => _MehndiHomePageState();
}

class _MehndiHomePageState extends State<MehndiHomePage> {
  final _workKey = GlobalKey();
  final _servicesKey = GlobalKey();
  final _contactKey = GlobalKey();
  bool _menuOpen = false;

  Future<void> _launchContact(Uri uri) async {
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the contact link.')),
      );
    }
  }

  Future<void> _scrollTo(GlobalKey key) async {
    setState(() => _menuOpen = false);
    final targetContext = key.currentContext;
    if (targetContext == null) return;
    await Scrollable.ensureVisible(
      targetContext,
      duration: const Duration(milliseconds: 650),
      curve: Curves.easeInOutCubic,
      alignment: 0.06,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 760;
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _NavigationBar(
                  isMobile: isMobile,
                  menuOpen: _menuOpen,
                  onMenuTap: () => setState(() => _menuOpen = !_menuOpen),
                  onWorkTap: () => _scrollTo(_workKey),
                  onServicesTap: () => _scrollTo(_servicesKey),
                  onContactTap: () => _scrollTo(_contactKey),
                ),
                _PageContent(
                  isMobile: isMobile,
                  workKey: _workKey,
                  servicesKey: _servicesKey,
                  contactKey: _contactKey,
                  onWorkTap: () => _scrollTo(_workKey),
                  onServicesTap: () => _scrollTo(_servicesKey),
                  onContactTap: () => _scrollTo(_contactKey),
                  onWhatsAppTap: () => _launchContact(
                    Uri.https('wa.me', '/919037211596', {
                      'text': 'Hi Henna Artistry! I would like to enquire about booking mehndi for my event. Please share your availability.',
                    }),
                  ),
                  onInstagramTap: () => _launchContact(
                    Uri.parse('https://www.instagram.com/henna._.artistryy/'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _NavigationBar extends StatelessWidget {
  const _NavigationBar({
    required this.isMobile,
    required this.menuOpen,
    required this.onMenuTap,
    required this.onWorkTap,
    required this.onServicesTap,
    required this.onContactTap,
  });

  final bool isMobile;
  final bool menuOpen;
  final VoidCallback onMenuTap;
  final VoidCallback onWorkTap;
  final VoidCallback onServicesTap;
  final VoidCallback onContactTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 22 : 52,
            vertical: 22,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const _BrandMark(),
                  const Spacer(),
                  if (isMobile)
                    IconButton(
                      onPressed: onMenuTap,
                      tooltip: menuOpen ? 'Close menu' : 'Open menu',
                      icon: Icon(menuOpen ? Icons.close : Icons.menu_rounded),
                    )
                  else ...[
                    _NavLink(label: 'Gallery', onTap: onWorkTap),
                    const SizedBox(width: 34),
                    _NavLink(label: 'Services', onTap: onServicesTap),
                    const SizedBox(width: 34),
                    _NavContactButton(onPressed: onContactTap),
                  ],
                ],
              ),
              if (isMobile && menuOpen)
                Padding(
                  padding: const EdgeInsets.only(top: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _MobileNavLink(label: 'Gallery', onTap: onWorkTap),
                      _MobileNavLink(label: 'Services', onTap: onServicesTap),
                      _MobileNavLink(
                        label: 'Book your date',
                        onTap: onContactTap,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: const BoxDecoration(
            color: _henna,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.spa_rounded, size: 18, color: _paper),
        ),
        const SizedBox(width: 10),
        const Text(
          'HENNA ARTISTRY',
          style: TextStyle(
            color: _ink,
            fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }
}

class _NavLink extends StatelessWidget {
  const _NavLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(foregroundColor: _ink),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
    );
  }
}

class _MobileNavLink extends StatelessWidget {
  const _MobileNavLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        alignment: Alignment.centerLeft,
        foregroundColor: _ink,
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _NavContactButton extends StatelessWidget {
  const _NavContactButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: _ink,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
      child: const Text('Book your date'),
    );
  }
}

class _PageContent extends StatelessWidget {
  const _PageContent({
    required this.isMobile,
    required this.workKey,
    required this.servicesKey,
    required this.contactKey,
    required this.onWorkTap,
    required this.onServicesTap,
    required this.onContactTap,
    required this.onWhatsAppTap,
    required this.onInstagramTap,
  });

  final bool isMobile;
  final GlobalKey workKey;
  final GlobalKey servicesKey;
  final GlobalKey contactKey;
  final VoidCallback onWorkTap;
  final VoidCallback onServicesTap;
  final VoidCallback onContactTap;
  final VoidCallback onWhatsAppTap;
  final VoidCallback onInstagramTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 22 : 52),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _HeroSection(isMobile: isMobile, onWorkTap: onWorkTap),
              const SizedBox(height: 110),
              _WorkSection(key: workKey, isMobile: isMobile),
              const SizedBox(height: 110),
              _ServicesSection(key: servicesKey, isMobile: isMobile),
              const SizedBox(height: 110),
              _ContactSection(
                key: contactKey,
                isMobile: isMobile,
                onWhatsAppTap: onWhatsAppTap,
                onInstagramTap: onInstagramTap,
              ),
              const SizedBox(height: 34),
              _Footer(
                isMobile: isMobile,
                onServicesTap: onServicesTap,
                onContactTap: onContactTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.isMobile, required this.onWorkTap});

  final bool isMobile;
  final VoidCallback onWorkTap;

  @override
  Widget build(BuildContext context) {
    final textColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Eyebrow(label: 'HENNA ARTISTRY · KOCHI & KOTTAYAM'),
        const SizedBox(height: 26),
        Text(
          'Henna art,\nmade for you.',
          style: TextStyle(
            color: _ink,
            fontSize: isMobile ? 53 : 76,
            height: 0.98,
            fontWeight: FontWeight.w700,
            letterSpacing: isMobile ? -2.6 : -4.4,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Custom mehndi designs for every occasion, made with care in Kochi and Kottayam, Kerala.',
          style: TextStyle(color: _muted, fontSize: 17, height: 1.65),
        ),
        const SizedBox(height: 32),
        _DarkActionButton(label: 'Explore the designs', onPressed: onWorkTap),
        const SizedBox(height: 28),
        const Row(
          children: [
            _AvailabilityDot(),
            SizedBox(width: 10),
            Flexible(
              child: Text(
                'Taking bookings for celebrations',
                style: TextStyle(color: _muted, fontSize: 13),
              ),
            ),
          ],
        ),
      ],
    );

    final visual = const _HeroArtwork();
    return Padding(
      padding: EdgeInsets.only(top: isMobile ? 40 : 72),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [textColumn, const SizedBox(height: 46), visual],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 5, child: textColumn),
                const SizedBox(width: 42),
                Expanded(flex: 6, child: visual),
              ],
            ),
    );
  }
}

class _HeroArtwork extends StatelessWidget {
  const _HeroArtwork();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.05,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'lib/image/photo_2026-11-04_23-56-04.jpg',
              fit: BoxFit.cover,
              alignment: const Alignment(0, -0.25),
              semanticLabel: 'Floral mehndi design on a hand against greenery',
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0x66000000)],
                  stops: [0.45, 1],
                ),
              ),
            ),
            Positioned(
              right: 24,
              top: 24,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: _paper,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Row(
                  children: [
                    _AvailabilityDot(),
                    SizedBox(width: 8),
                    Text(
                      'MADE WITH MEANING',
                      style: TextStyle(
                        color: _ink,
                        fontSize: 9,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 22,
              bottom: 22,
              child: _ArtworkNote(
                icon: Icons.favorite_border_rounded,
                title: 'Made for your moment',
                subtitle: 'Hand-drawn, personal mehndi.',
              ),
            ),
            Positioned(
              right: 25,
              bottom: 28,
              child: Transform.rotate(
                angle: -0.12,
                child: Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    color: _ink,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.local_florist_outlined,
                    color: _henna,
                    size: 30,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 28,
              top: 32,
              child: Transform.rotate(
                angle: 0.18,
                child: const Icon(
                  Icons.add_rounded,
                  size: 34,
                  color: Color(0xFF9A9D91),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArtworkNote extends StatelessWidget {
  const _ArtworkNote({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _paper,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, size: 22, color: _ink),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: _ink,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(color: _muted, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WorkSection extends StatelessWidget {
  const _WorkSection({super.key, required this.isMobile});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    const designs = [
      _DesignData(
        title: 'Bridal statement',
        category: 'Intricate full-hand work',
        image: 'lib/image/photo_2026-11-04_23-56-09.jpg',
        caption: 'A story in every detail',
      ),
      _DesignData(
        title: 'Floral elegance',
        category: 'Classic bridal design',
        image: 'lib/image/photo_2026-11-04_23-56-04.jpg',
        caption: 'Inspired by flowers and tradition',
      ),
      _DesignData(
        title: 'Fine-line florals',
        category: 'Custom occasion mehndi',
        image: 'lib/image/photo_2026-11-04_23-56-02.jpg',
        caption: 'A little art in the palm of your hand',
      ),
      _DesignData(
        title: 'Traditional details',
        category: 'Hands & feet',
        image: 'lib/image/photo_2026-11-04_23-56-00.jpg',
        caption: 'Made slowly, with love',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionHeading(
          eyebrow: 'THE MEHNDI GALLERY',
          title: 'Mehndi for every moment',
          isMobile: isMobile,
        ),
        const SizedBox(height: 30),
        LayoutBuilder(
          builder: (context, constraints) {
            final columnCount = isMobile ? 1 : 2;
            final cardWidth =
                (constraints.maxWidth - (columnCount - 1) * 22) / columnCount;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: designs.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columnCount,
                crossAxisSpacing: 22,
                mainAxisSpacing: 26,
                mainAxisExtent: cardWidth / 1.08 + 120,
              ),
              itemBuilder: (context, index) =>
                  _ProjectCard(data: designs[index]),
            );
          },
        ),
      ],
    );
  }
}

class _DesignData {
  const _DesignData({
    required this.title,
    required this.category,
    required this.image,
    required this.caption,
  });

  final String title;
  final String category;
  final String image;
  final String caption;
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.data});

  final _DesignData data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AspectRatio(
          aspectRatio: 1.08,
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: const Color(0xFFE9D5C9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    data.image,
                    fit: BoxFit.cover,
                    semanticLabel: data.title,
                  ),
                ),
                const Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0x8C000000)],
                        stops: [0.55, 1],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 20,
                  bottom: 18,
                  child: Text(
                    data.caption,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Positioned(
                  right: 18,
                  top: 18,
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: const BoxDecoration(
                      color: _paper,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.north_east_rounded,
                      color: _ink,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final titleWidget = Text(
              data.title,
              style: const TextStyle(
                color: _ink,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            );
            final categoryWidget = Text(
              data.category,
              style: const TextStyle(color: _muted, fontSize: 12),
            );
            if (constraints.maxWidth < 620) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  titleWidget,
                  const SizedBox(height: 4),
                  categoryWidget,
                ],
              );
            }
            return Row(children: [titleWidget, const Spacer(), categoryWidget]);
          },
        ),
      ],
    );
  }
}

class _ServicesSection extends StatelessWidget {
  const _ServicesSection({super.key, required this.isMobile});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    const services = [
      _ServiceData(
        number: '01',
        icon: Icons.favorite_border_rounded,
        title: 'Bridal mehndi',
        description: 'Personal bridal designs, from delicate details to full hands and feet, planned around your celebration.',
      ),
      _ServiceData(
        number: '02',
        icon: Icons.local_florist_outlined,
        title: 'Engagement & festive',
        description: 'Beautiful henna for engagements, festivals, birthdays, and all the moments in between.',
      ),
      _ServiceData(
        number: '03',
        icon: Icons.groups_2_outlined,
        title: 'Guests & group bookings',
        description: 'Matching or individual designs for your guests, with group bookings available for events.',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionHeading(
          eyebrow: 'MEHNDI SERVICES',
          title: 'Made for your occasion',
          isMobile: isMobile,
        ),
        const SizedBox(height: 30),
        if (isMobile)
          Column(
            children: [
              for (var index = 0; index < services.length; index++) ...[
                _ServiceCard(data: services[index]),
                if (index != services.length - 1) const SizedBox(height: 14),
              ],
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var index = 0; index < services.length; index++) ...[
                Expanded(child: _ServiceCard(data: services[index])),
                if (index != services.length - 1) const SizedBox(width: 16),
              ],
            ],
          ),
      ],
    );
  }
}

class _ServiceData {
  const _ServiceData({
    required this.number,
    required this.icon,
    required this.title,
    required this.description,
  });

  final String number;
  final IconData icon;
  final String title;
  final String description;
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.data});

  final _ServiceData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFEDEEE8),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(data.icon, color: _ink, size: 24),
              const Spacer(),
              Text(
                data.number,
                style: const TextStyle(color: _muted, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 28),
          Text(
            data.title,
            style: const TextStyle(
              color: _ink,
              fontSize: 21,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            data.description,
            style: const TextStyle(color: _muted, fontSize: 14, height: 1.6),
          ),
        ],
      ),
    );
  }
}

class _ContactSection extends StatelessWidget {
  const _ContactSection({
    super.key,
    required this.isMobile,
    required this.onWhatsAppTap,
    required this.onInstagramTap,
  });

  final bool isMobile;
  final VoidCallback onWhatsAppTap;
  final VoidCallback onInstagramTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 28 : 54),
      decoration: BoxDecoration(
        color: _contactSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _henna.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ContactCopy(isMobile: isMobile),
          const SizedBox(height: 20),
          const Text(
            'Kochi & Kottayam, Kerala',
            style: TextStyle(color: _ink, fontSize: 15),
          ),
          const SizedBox(height: 8),
          const Text(
            '@henna._.artistryy',
            style: TextStyle(color: _ink, fontSize: 14),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _ContactButton(
                label: 'Book on WhatsApp',
                icon: Icons.chat_rounded,
                backgroundColor: _whatsAppGreen,
                onPressed: onWhatsAppTap,
              ),
              _ContactButton(
                label: 'Message on Instagram',
                icon: Icons.camera_alt_outlined,
                onPressed: onInstagramTap,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContactCopy extends StatelessWidget {
  const _ContactCopy({required this.isMobile});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Eyebrow(label: 'NOW BOOKING CELEBRATIONS'),
        const SizedBox(height: 16),
        Text(
          'Your day,\nbeautifully told.',
          style: TextStyle(
            color: _ink,
            fontSize: isMobile ? 38 : 54,
            height: 1.05,
            letterSpacing: isMobile ? -1.7 : -2.5,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'Custom mehndi designs for every occasion. Message on WhatsApp or Instagram to check availability and book.',
          style: TextStyle(color: _ink, fontSize: 15, height: 1.55),
        ),
      ],
    );
  }
}

class _ContactButton extends StatelessWidget {
  const _ContactButton({
    required this.label,
    required this.icon,
    this.backgroundColor = _ink,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final Color backgroundColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 19),
      ),
      icon: Icon(icon, size: 18),
      label: Text(label),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({
    required this.isMobile,
    required this.onServicesTap,
    required this.onContactTap,
  });

  final bool isMobile;
  final VoidCallback onServicesTap;
  final VoidCallback onContactTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _BrandMark(),
                const SizedBox(height: 20),
                _NavLink(label: 'Services', onTap: onServicesTap),
                _NavLink(label: 'Contact', onTap: onContactTap),
                const SizedBox(height: 12),
                const Text(
                  'Kochi & Kottayam, Kerala',
                  style: TextStyle(color: _muted, fontSize: 12),
                ),
              ],
            )
          : Row(
              children: [
                const _BrandMark(),
                const SizedBox(width: 30),
                const Text(
                  'Kochi & Kottayam, Kerala',
                  style: TextStyle(color: _muted, fontSize: 12),
                ),
                const Spacer(),
                _NavLink(label: 'Services', onTap: onServicesTap),
                _NavLink(label: 'Contact', onTap: onContactTap),
              ],
            ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({
    required this.eyebrow,
    required this.title,
    required this.isMobile,
  });

  final String eyebrow;
  final String title;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Eyebrow(label: eyebrow),
        const SizedBox(height: 12),
        Text(
          title,
          style: TextStyle(
            color: _ink,
            fontSize: isMobile ? 34 : 48,
            fontWeight: FontWeight.w700,
            letterSpacing: isMobile ? -1.4 : -2.5,
          ),
        ),
      ],
    );
  }
}

class _Eyebrow extends StatelessWidget {
  const _Eyebrow({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: _muted,
        fontSize: 10,
        letterSpacing: 1.8,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _DarkActionButton extends StatelessWidget {
  const _DarkActionButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: _ink,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
      ),
      icon: const Icon(Icons.arrow_downward_rounded, size: 17),
      label: Text(label),
    );
  }
}

class _AvailabilityDot extends StatelessWidget {
  const _AvailabilityDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: Color(0xFF82AF3B),
        shape: BoxShape.circle,
      ),
    );
  }
}
