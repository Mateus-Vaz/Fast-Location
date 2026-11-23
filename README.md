# FastLocation

Aplicativo Flutter para Android e iOS desenvolvido para a FastDelivery. Permite que o entregador consulte o endereço de um CEP e descubra o CEP de um endereço completo ou parcial, sem depender de contato com a matriz e sem atrasar a entrega.

Autor: Mateus Vaz

## Funcionalidades

- Tela de abertura animada, com redirecionamento automático para a Home.
- Consulta de endereço por CEP.
- Busca de CEP por UF, cidade e logradouro (completo ou parcial).
- Armazenamento local das consultas, usado como cache e como fonte do histórico.
- Exibição do último endereço consultado e da lista de resultados.
- Indicador de carregamento durante as requisições externas.
- Componente específico para resultado não encontrado.
- Opção de nova consulta, que limpa os campos e o estado atual.
- Tela de histórico, carregada automaticamente ao ser aberta.
- Rota da posição atual do aparelho até o último endereço consultado, aberta no aplicativo de mapas instalado.
- Tema claro e escuro: segue o sistema por padrão e pode ser alternado pelo botão no topo da Home. A escolha fica salva no aparelho.

## Como cada requisito foi atendido

| Requisito | Solução |
|---|---|
| API pública de CEP e endereços | ViaCEP, acessada com Dio: `/ws/{cep}/json/` e `/ws/{uf}/{cidade}/{logradouro}/json/` |
| Consultas recorrentes | Hive guarda cada endereço consultado. Um CEP já salvo é respondido pelo aparelho, sem nova chamada à API |
| Estado reativo | MobX, com `Observer` nas telas e `reaction` para exibir os erros |
| Tema claro/escuro | `AppTheme` define os dois temas e `ThemeController` guarda a escolha no Hive |
| Rota até o destino | `geocoding` converte o endereço em coordenadas e `map_launcher` abre o app de mapas com a rota |

## Tecnologias

- Flutter e Dart
- Dio (requisições HTTP)
- MobX, flutter_mobx e mobx_codegen (estado reativo)
- Hive, hive_flutter e hive_generator (armazenamento local)
- geocoding e map_launcher (endereço para coordenadas e abertura do mapa)
- path e path_provider (diretório de armazenamento)
- build_runner (geração de código)

## Arquitetura

O projeto segue Clean Architecture modular. Cada módulo separa interface, estado, regras de negócio e acesso a dados:

- Página: monta a interface e observa o controller.
- Controller (MobX): guarda o estado da tela, sem lógica de interface. Os erros são expostos como estado e a página reage a eles para exibir o alerta.
- Service: validações, regras de negócio e decisão entre cache e API.
- Repositories: um para a comunicação externa (ViaCEP) e outro para a leitura e escrita no Hive.
- Model: `AddressModel`, com os campos do ViaCEP, conversão de JSON e adapter do Hive.

Fluxo de uma consulta por CEP:

1. A página envia o CEP ao controller.
2. O controller chama o service, que valida o formato (8 dígitos).
3. O service procura o CEP no Hive. Se encontrar, devolve o endereço salvo.
4. Se não encontrar, consulta o ViaCEP, grava o resultado no Hive e devolve o endereço.
5. O controller atualiza o estado e a interface reage.

## Estrutura de diretórios

```text
lib/
├── main.dart
└── src/
    ├── app_widget.dart
    ├── http/
    │   └── app_http_client.dart
    ├── routes/
    │   └── app_routes.dart
    ├── shared/
    │   ├── colors/
    │   │   └── app_colors.dart
    │   ├── components/
    │   │   ├── address_tile.dart
    │   │   ├── app_text_field.dart
    │   │   ├── gradient_header.dart
    │   │   └── loading_overlay.dart
    │   ├── metrics/
    │   │   └── app_metrics.dart
    │   ├── storage/
    │   │   └── hive_config.dart
    │   └── theme/
    │       ├── app_theme.dart
    │       └── theme_controller.dart
    └── modules/
        ├── initial/
        │   └── page/
        │       └── initial_page.dart
        ├── home/
        │   ├── components/
        │   │   ├── address_list.dart
        │   │   ├── empty_search.dart
        │   │   ├── last_address.dart
        │   │   └── search_form.dart
        │   ├── controller/
        │   │   ├── home_controller.dart
        │   │   └── home_controller.g.dart
        │   ├── model/
        │   │   ├── address_model.dart
        │   │   └── address_model.g.dart
        │   ├── page/
        │   │   └── home_page.dart
        │   ├── repositories/
        │   │   ├── address_local_repository.dart
        │   │   └── via_cep_repository.dart
        │   └── service/
        │       ├── address_exception.dart
        │       ├── address_service.dart
        │       └── route_service.dart
        └── history/
            ├── controller/
            │   ├── history_controller.dart
            │   └── history_controller.g.dart
            └── page/
                └── history_page.dart

test/
├── address_service_test.dart
├── fakes.dart
└── home_controller_test.dart
```

## Como executar

Pré-requisitos: Flutter instalado, Android SDK e um emulador ou aparelho conectado. O comando `flutter doctor` deve estar sem erros na parte Android.

```bash
git clone <url-do-repositorio>
cd fastlocation
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

Os arquivos `*.g.dart` acompanham o projeto. O passo do `build_runner` só é necessário quando o model ou os controllers forem alterados.

## Como usar

1. A tela de abertura é exibida e o app segue para a Home.
2. O botão de sol/lua no topo da Home alterna entre tema claro e escuro.
3. Consulta por CEP: digite os 8 números e confirme. O endereço aparece em destaque como último endereço consultado.
4. Consulta por endereço: informe UF, cidade e parte do logradouro (o ViaCEP exige no mínimo 3 caracteres). Os resultados aparecem em lista.
5. Nova consulta limpa os campos e o resultado atual.
6. O acesso ao histórico fica na Home e lista os endereços salvos no aparelho.
7. Traçar rota abre o aplicativo de mapas instalado, com origem na posição atual do aparelho e destino no último endereço consultado. Se não houver aplicativo de mapas, o app avisa.

## Configuração nativa

Android (`android/app/src/main/AndroidManifest.xml`):

- Permissão de internet para acessar o ViaCEP.
- Bloco `<queries>` com os esquemas `geo` e `https`, necessário no Android 11 ou superior para o `map_launcher` encontrar os aplicativos de mapas.

iOS (`ios/Runner/Info.plist`):

- `LSApplicationQueriesSchemes` com os esquemas dos aplicativos de mapas (por exemplo `comgooglemaps` e `waze`).
- Plataforma mínima definida no `ios/Podfile`.

O app não solicita permissão de localização. A posição atual é usada pelo próprio aplicativo de mapas como origem da rota.

## Versões e compatibilidade

O projeto usa Dart 3 (`sdk: ^3.13.7` no `pubspec.yaml`), então deve ser executado com um Flutter recente que traga essa versão do Dart. Basta o Flutter estável mais atual: não é preciso FVM nem uma versão antiga do Flutter.

Algumas dependências são antigas (`dio` 4, `hive_generator` 2, `mobx_codegen` 2). Elas funcionam com o `pubspec.lock` incluído. Se o `flutter pub get` ou o `build_runner` falharem na resolução ao atualizar pacotes, atualize `mobx`, `flutter_mobx`, `mobx_codegen`, `build_runner` e `hive_generator` para versões compatíveis com o seu Dart. A API do `dio` 5 mudou em alguns pontos usados aqui (`DioError` virou `DioException` e os timeouts passaram a ser `Duration`), então a migração exige ajustar `app_http_client.dart` e `address_service.dart`.

Observações:

- `path_provider_android` e `path_provider_ios` são redundantes, pois o `path_provider` já os traz como dependência. O `path_provider_ios` está descontinuado e foi substituído pelo `path_provider_foundation`. Ambos foram mantidos no `pubspec.yaml` por constarem nas dependências do escopo e podem ser removidos sem impacto.
- `dio` 4.0.6 possui um alerta de segurança de injeção de CRLF quando o método HTTP vem de texto controlado pelo usuário. O app só realiza requisições `GET` com método fixo, então não é afetado.