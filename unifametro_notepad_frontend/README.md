# Flutter Notes CRUD App

Aplicativo simples de notas (semelhante ao Notepad) desenvolvido com Flutter. Permite listar, cadastrar, editar e excluir notas via API REST.

## Features
- Flutter + API REST
- Arquitetura MVVM com Clean Architecture e SOLID
- Gerenciamento de estado com BLoC (Cubit)
- Tratamento de erros: 401, 500, sem internet
- Testes unitários, de integração e de widget com `flutter_test` e `mockito`

## Estrutura de Pastas
- **core**: Serviços, exceções e constantes globais
- **data**: Camada de dados e integração com API
- **domain**: Regras de negócio e contratos
- **presentation**: Cubits e telas (views)

## Packages Usados
- `http`: Comunicação REST
- `flutter_bloc`: Gerenciamento de estado com BLoC
- `mockito`: Mock para testes
- `flutter_test`: Testes unitários e de widget

## Testes
- Unitários para o NoteCubit
- Integração com API mockada
- Testes de widget com interação simulada