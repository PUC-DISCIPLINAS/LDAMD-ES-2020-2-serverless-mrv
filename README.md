# ![Flutter logo][]

<h1 align="center">
    <a href="https://developers.google.com/learn/topics/functions">Serverless com o Google Cloud Functions - GCF 🔗 </a>
</h1>

<p align="center">
 <a href="#%EF%B8%8F-especificações">Especificações</a> •
 <a href="#-instruções">Instruções</a> • 
 <a href="#cloud-google-cloud-function">Google Cloud Functions</a> • 
 <a href="#iphone-demonstração">Demonstração</a> • 
 <a href="#-dependências">Dependências</a> • 
 <a href="#busts_in_silhouette-alunos">Alunos</a> • 
 <a href="#-professor-responsável">Professor Responsável</a> 
</p>

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


### :cloud: Google Cloud Function

```
"""
    Google Clound Function to calculate distance between two coordinates.
    Source code: (https://github.com/chirichignoa/ParkingRecommender/blob/4c1d7a4dcfa98fe459ab54cb7aaac37c68214231/HaversineDistanceService/app.py)
    Haversine: (https://en.wikipedia.org/wiki/Haversine_formula)
"""

"""
    Function to convert degrees to radians 
"""

def degrees_to_radians(degrees):
    return degrees * pi / 180


def get_haversine(lat_s, lng_s, lat_d, lng_d):
    earth_radius_km = 6371
    d_lat = degrees_to_radians(lat_d - lat_s)
    d_lon = degrees_to_radians(lng_d - lng_s)

    a = sin(d_lat / 2) * sin(d_lat / 2) + sin(d_lon / 2) * sin(d_lon / 2) * cos(lat_s) * cos(lat_d)
    c = 2 * atan2(sqrt(a), sqrt(1 - a))
    return (earth_radius_km * c) * 1000


def hello_world(request):
    """Responds to any HTTP request.
    Args:
        request (flask.Request): HTTP request object.
    Returns:
        The response text or any set of values that can be turned into a
        Response object using
        `make_response <http://flask.pocoo.org/docs/1.0/api/#flask.Flask.make_response>`.
    """
    request_json = request.get_json()

    lat_s = float(request.args.get('lat_s', None))
    lng_s = float(request.args.get('lng_s', None))
    lat_d = float(request.args.get('lat_d', None))
    lng_d = float(request.args.get('lng_d', None))
    if (lat_s is None) or (lng_s is None) or (lat_d is None) or (lng_d is None):
        return make_response(jsonify("The request does not have neccessary parameters"), 400)
    distance = get_haversine(lat_s, lng_s, lat_d, lng_d)
    if(distance < 100):
        return make_response(jsonify(
                                {'distance': get_haversine(lat_s, lng_s, lat_d, lng_d), 'response': True}
                            ), 200)
    return make_response(jsonify(
                                {'distance': get_haversine(lat_s, lng_s, lat_d, lng_d), 'response': False}
                            ), 200)
```

- A função acima é responsável por retornar um JSON com o cálculo utilizando à fórmula de Haversine que é responsável por encontrar a distância entre dois pontos geográficos a partir de suas latitudes e longitudes. 
- A função foi escrita em Python pela facilidade da manipulação dos dados, e foi utilizado o Micro-framework chamado Flask. Portanto, foi-se utilizado também a propriedade _args_ para que fosse possível analisar os parâmetros passados na _query_ da URL. 
- O _trigger_ para chamar a função está disponível nesse link: https://us-central1-clean-axiom-294822.cloudfunctions.net/distances
- Algumas métricas disponíveis no site:

![image](https://user-images.githubusercontent.com/30940498/100148962-3aaa6500-2e7c-11eb-82c0-a1f1d9b7a4cc.png)


### :iphone: Demonstração

![ezgif com-gif-maker](https://user-images.githubusercontent.com/30940498/100150439-629ac800-2e7e-11eb-8c11-702c8176ee5e.gif)

Link da demonstração: https://youtu.be/9dXjdV5qtLg

As modificações de localização do usuário foram realizadas pelo próprio emulador:
![image](https://user-images.githubusercontent.com/30940498/100460726-6dd03c80-30a6-11eb-9417-b520b5d584a4.png)

### ✋🏻 Dependências

- IDE (Visual Studio Code / Android Studio).
- Emulador (Android Studio AVD / Genymotion).
- Dentro de (android/app/src/main/AndroidManifest.xml) há algumas dependências relacionadas com Google Maps e o Geolocator.

### :busts_in_silhouette: Alunos

* Matheus Santos Rosa Carneiro - [mcarneirobug](https://github.com/mcarneirobug)
* Raissa Carolina Vilela da Silva - [raissavilela](https://github.com/raissavilela)
* Vitor Augusto Alves de Jesus - [ovitorj](https://github.com/ovitorj)

### 📝 Professor responsável

* Hugo Bastos de Paula - [hugodepaula](https://github.com/hugodepaula)

<h4 align="center"> 
	🚧 Serveless GCF 🚀 finalizado... 🚧
</h4>

[Flutter logo]: https://raw.githubusercontent.com/flutter/website/master/src/_assets/image/flutter-lockup.png
