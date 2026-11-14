import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/brand.dart';
import '../../../app/theme.dart';
import '../../../core/game/hero_profile.dart';
import '../../../data/repositories/providers.dart';

/// Criação do herói: prólogo → nome → origem → juramento.
///
/// Ao concluir, o herói é salvo e o roteador leva automaticamente
/// para a tela do personagem.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  static const _stepCount = 4;

  final _pageController = PageController();
  final _nameController = TextEditingController();
  final _oathController = TextEditingController();

  int _step = 0;
  HeroForm _form = HeroForm.masculine;
  HeroOrigin? _origin;
  bool _saving = false;
  String? _nameError;

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _oathController.dispose();
    super.dispose();
  }

  bool get _canAdvance => switch (_step) {
        1 => HeroProfile.validateName(_nameController.text) == null,
        2 => _origin != null,
        _ => true,
      };

  void _goTo(int step) {
    FocusScope.of(context).unfocus();
    setState(() => _step = step);
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  void _next() {
    if (_step == 1) {
      final error = HeroProfile.validateName(_nameController.text);
      if (error != null) {
        setState(() => _nameError = error);
        return;
      }
    }
    if (_step < _stepCount - 1) {
      _goTo(_step + 1);
    } else {
      _forgeHero();
    }
  }

  Future<void> _forgeHero() async {
    setState(() => _saving = true);
    try {
      await ref.read(heroRepositoryProvider).createHero(
            name: _nameController.text,
            form: _form,
            origin: _origin!,
            oath: _oathController.text,
          );
      // O roteador observa o herói e redireciona sozinho.
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não foi possível forjar o herói: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _PrologueStep(),
                  _NameStep(
                    controller: _nameController,
                    form: _form,
                    errorText: _nameError,
                    onFormChanged: (f) => setState(() => _form = f),
                    onNameChanged: (_) => setState(() => _nameError = null),
                    onSubmitted: _next,
                  ),
                  _OriginStep(
                    selected: _origin,
                    onSelected: (o) => setState(() => _origin = o),
                  ),
                  _OathStep(
                    controller: _oathController,
                    name: _nameController.text.trim(),
                    form: _form,
                    origin: _origin,
                  ),
                ],
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 56,
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
      child: Row(
        children: [
          SizedBox(
            width: 48,
            child: _step > 0
                ? IconButton(
                    tooltip: 'Voltar',
                    icon: const Icon(Icons.arrow_back, color: AppTheme.dullSilver),
                    onPressed: _saving ? null : () => _goTo(_step - 1),
                  )
                : null,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_stepCount, (i) {
                final active = i <= _step;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: i == _step ? 28 : 10,
                  height: 6,
                  decoration: BoxDecoration(
                    color: active ? AppTheme.emberGold : AppTheme.ironBorder,
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    final label = switch (_step) {
      0 => 'Iniciar a Jornada',
      3 => 'Forjar Herói',
      _ => 'Continuar',
    };
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: AppTheme.emberGold,
            foregroundColor: AppTheme.obsidianBlack,
            disabledBackgroundColor: AppTheme.ironBorder,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: _saving || !_canAdvance ? null : _next,
          child: _saving
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2.5, color: AppTheme.obsidianBlack),
                )
              : Text(
                  label.toUpperCase(),
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppTheme.obsidianBlack,
                        fontSize: 15,
                      ),
                ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Passos
// ---------------------------------------------------------------------------

class _StepScaffold extends StatelessWidget {
  const _StepScaffold({required this.title, required this.children, this.subtitle});

  final String title;
  final String? subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      children: [
        Text(title, style: textTheme.headlineMedium?.copyWith(color: AppTheme.emberGold)),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(subtitle!, style: textTheme.bodyMedium),
        ],
        const SizedBox(height: 24),
        ...children,
      ],
    );
  }
}

class _PrologueStep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
      children: [
        Center(
          child: Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: AppTheme.castIron,
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.emberGold, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.emberOrange.withValues(alpha: 0.35),
                  blurRadius: 32,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(Icons.local_fire_department, color: AppTheme.emberGold, size: 48),
          ),
        ),
        const SizedBox(height: 28),
        Text(
          AppBrand.appName,
          textAlign: TextAlign.center,
          style: textTheme.displaySmall?.copyWith(color: AppTheme.emberGold),
        ),
        const SizedBox(height: 4),
        Text(
          AppBrand.subtitle,
          textAlign: TextAlign.center,
          style: textTheme.titleMedium?.copyWith(color: AppTheme.dullSilver),
        ),
        const SizedBox(height: 28),
        Text(
          'Nas terras cinzentas, heróis não nascem escolhidos pelos deuses. '
          'Eles se forjam — repetição após repetição, noite após noite, '
          'na dor e na disciplina.',
          textAlign: TextAlign.center,
          style: textTheme.bodyLarge?.copyWith(height: 1.5),
        ),
        const SizedBox(height: 28),
        const _LoreRow(icon: Icons.fitness_center, text: 'Treinos reais forjam Força, Destreza e Constituição.'),
        const _LoreRow(icon: Icons.menu_book, text: 'Estudo afia a Inteligência; meditação, a Sabedoria.'),
        const _LoreRow(icon: Icons.auto_awesome, text: 'Sua classe não é escolhida: ela emerge dos seus hábitos.'),
      ],
    );
  }
}

class _LoreRow extends StatelessWidget {
  const _LoreRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.emberGold),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyMedium)),
        ],
      ),
    );
  }
}

class _NameStep extends StatelessWidget {
  const _NameStep({
    required this.controller,
    required this.form,
    required this.errorText,
    required this.onFormChanged,
    required this.onNameChanged,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final HeroForm form;
  final String? errorText;
  final ValueChanged<HeroForm> onFormChanged;
  final ValueChanged<String> onNameChanged;
  final VoidCallback onSubmitted;

  @override
  Widget build(BuildContext context) {
    return _StepScaffold(
      title: 'Quem é você?',
      subtitle: 'O nome que os bardos cantarão — ou que os corvos esquecerão.',
      children: [
        TextField(
          controller: controller,
          maxLength: HeroProfile.maxNameLength,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          style: const TextStyle(color: AppTheme.ashWhite, fontSize: 18),
          onChanged: onNameChanged,
          onSubmitted: (_) => onSubmitted(),
          decoration: InputDecoration(
            labelText: 'Nome do herói',
            errorText: errorText,
            filled: true,
            fillColor: AppTheme.castIron,
            prefixIcon: const Icon(Icons.edit, color: AppTheme.emberGold),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.emberGold),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text('Como o narrador deve se referir a você?', style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          children: [
            for (final f in HeroForm.values)
              ChoiceChip(
                label: Text('${f.label} · ${f.title}'),
                selected: form == f,
                onSelected: (_) => onFormChanged(f),
                selectedColor: AppTheme.emberGold,
                backgroundColor: AppTheme.castIron,
                labelStyle: TextStyle(
                  color: form == f ? AppTheme.obsidianBlack : AppTheme.ashWhite,
                  fontWeight: FontWeight.w600,
                ),
                side: BorderSide(color: form == f ? AppTheme.emberGold : AppTheme.ironBorder),
                showCheckmark: false,
              ),
          ],
        ),
      ],
    );
  }
}

class _OriginStep extends StatelessWidget {
  const _OriginStep({required this.selected, required this.onSelected});

  final HeroOrigin? selected;
  final ValueChanged<HeroOrigin> onSelected;

  @override
  Widget build(BuildContext context) {
    return _StepScaffold(
      title: 'De onde você veio?',
      subtitle: 'Sua origem é apenas história: ela não muda seus atributos. '
          'Quem decide seus números é o seu esforço.',
      children: [
        for (final origin in HeroOrigin.values)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _OriginCard(
              origin: origin,
              selected: origin == selected,
              onTap: () => onSelected(origin),
            ),
          ),
      ],
    );
  }
}

class _OriginCard extends StatelessWidget {
  const _OriginCard({required this.origin, required this.selected, required this.onTap});

  final HeroOrigin origin;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppTheme.forgedSteel : AppTheme.castIron,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? AppTheme.emberGold : AppTheme.ironBorder,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(origin.icon, style: const TextStyle(fontSize: 26)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      origin.name,
                      style: TextStyle(
                        color: selected ? AppTheme.emberGold : AppTheme.ashWhite,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      origin.description,
                      style: const TextStyle(color: AppTheme.dullSilver, fontSize: 13, height: 1.35),
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

class _OathStep extends StatelessWidget {
  const _OathStep({
    required this.controller,
    required this.name,
    required this.form,
    required this.origin,
  });

  final TextEditingController controller;
  final String name;
  final HeroForm form;
  final HeroOrigin? origin;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return _StepScaffold(
      title: 'Seu juramento',
      subtitle: 'Por que você treina? O narrador lembrará disso nos momentos difíceis. (Opcional)',
      children: [
        TextField(
          controller: controller,
          maxLength: HeroProfile.maxOathLength,
          maxLines: 3,
          style: const TextStyle(color: AppTheme.ashWhite),
          decoration: InputDecoration(
            hintText: 'Ex.: Ficar forte o bastante para carregar meus filhos sem dor nas costas.',
            hintStyle: const TextStyle(color: AppTheme.darkAsh),
            filled: true,
            fillColor: AppTheme.castIron,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.emberGold),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.castIron,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.emberGold.withValues(alpha: 0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name.isEmpty ? '—' : name, style: textTheme.titleLarge?.copyWith(color: AppTheme.emberGold)),
              const SizedBox(height: 4),
              Text(
                '${form.title} · ${origin?.name ?? '—'} · Nível 1',
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: 10),
              Text(
                'Todos os atributos começam em 10. A partir de agora, '
                'cada treino, cada página estudada e cada noite bem dormida conta.',
                style: textTheme.bodySmall?.copyWith(color: AppTheme.dullSilver, height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
