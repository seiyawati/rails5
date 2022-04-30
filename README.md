# Rails Tutorial

## コンテナ立ち上げ

`docker-compose up -d --build`

## テスト実行

`bundle exec rspec`

## Guardによるテスト自動化

`bundle exec guard`

## デバッグ方法

アタッチ
`docker-compose attach コンテナID`

検証する場所に以下を書く
`binding.pry`

デタッチ
`Ctrl+P, Ctrl+Q`
