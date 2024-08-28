import 'package:flutter/material.dart';
import 'package:mi_utem/core/models/user/persona/persona.dart';
import 'package:mi_utem/widgets/profile_photo.dart';

class PersonaDetalle extends StatelessWidget {
  final Persona estudiante;
  final String? fotoUrl, fotoBase64;

  const PersonaDetalle({
    super.key,
    required this.estudiante,
    this.fotoUrl,
    this.fotoBase64,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children: [
        ProfilePhoto(
          base64Data: fotoBase64,
          fotoUrl: fotoUrl,
          iniciales: estudiante.iniciales,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(estudiante.nombreCompletoCapitalizado,
                maxLines: 2,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 4),
              Text("${estudiante.rut}",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}