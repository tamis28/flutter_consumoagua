# Consumo de Água

App de controle de consumo de água.


```text
lib/
  main.dart
  models/
    water.dart
  screens/
    home_screens.dart
    splash_screens.dart
  services/
    storage_service.dart
  widgets/
    stat_card.dart
    water_form_dialog.dart
    water_item.dart
```

## Como rodar

```bash
flutter pub get
flutter run
```

## O que cada tela faz

- `Splash` - ícone do app, switch de tema escuro e botão `Entrar`.
- `Home` - lista de registros de água com data, quantidade em ml e peso atual, botão `+` para cadastrar, lixeira para excluir e toque no item para editar. Abaixo da lista, um gráfico de consumo.

## Regras

- Meta diária = `35 ml × peso atual (kg)`.
- O total do dia soma os registros com a mesma data.
- Os dados são salvos localmente com `SharedPreferences`, funcionando no celular e no web.

## Observação

- O `assets/icon.png` usado na Splash precisa existir e estar declarado no `pubspec.yaml`.