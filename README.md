<h1 align="center">
    <a href="https://developers.google.com/learn/topics/functions">Serverless com o Google Cloud Functions - GCF 🔗 </a>
</h1>

### ⌨️ Especificações

1. A aplicação móvel deve exibir o mapa da localização atual do telefone.
2. A aplicação móvel deve rastrear a localização do usuário.
3. A cada atualização de localização, a aplicação móvel deve invocar a função lambda do GCF.
4. A função lambda deve verificar se o aparelho se encontra a menos de 100 metros de alguma unidade da PUC Minas e retornar para o celular a mensagem
**"Bem vindo à PUC Minas unidade " + <nome da unidade mais próxima>.**

### 🛠 Instruções

1. Endpoint do google cloud function: https://us-central1-clean-axiom-294822.cloudfunctions.net/distances
2. Parâmetros: 	
	- lat_s
	- lng_s
	- lat_d
	- lng_d
3. Exemplo:
```
https://us-central1-clean-axiom-294822.cloudfunctions.net/distances?lat_s=-19.9333&lng_s=-43.9371&lat_d=-19.9334&lng_d=-43.9368
```

![image](https://user-images.githubusercontent.com/30940498/99136116-00320400-2602-11eb-9d0d-1d3307bf8f15.png)

4. Na plataforma do Firebase o recurso *Cloud Firestore* está armazenado os campus pertencentes a PUC MINAS, contendo os campos de latitude, longitude e o nome do campus.
![image](https://user-images.githubusercontent.com/30940498/99135530-6ff3bf00-2601-11eb-8992-4b83612e3605.png)

### :busts_in_silhouette: Alunos

* Matheus Santos Rosa Carneiro - [mcarneirobug](https://github.com/mcarneirobug)
* Raissa Carolina Vilela da Silva - [raissavilela](https://github.com/raissavilela)
* Vitor Augusto Alves de Jesus - [ovitorj](https://github.com/ovitorj)

### 📝 Professor responsável

* Hugo Bastos de Paula - [hugodepaula](https://github.com/hugodepaula)

<h4 align="center"> 
	🚧 Serveless GCF 🚀 em andamento... 🚧
</h4>
