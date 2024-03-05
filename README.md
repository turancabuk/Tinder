
# Tinder Clone


Bu proje, Tinder sosyal medya uygulaması temel alınarak geliştirilmiş bir uygulama klonudur. Bu çalışma sürecinde, Swift programlama dilinin gelişmiş özelliklerini kullanarak iOS geliştirme yeteneklerimi en ileri seviyeye taşıdım.

Uygulama çalıştırıldığında, kullanıcıya gösterilen Register ekranında, kullanıcıdan bir profil fotoğrafı, kullanıcı ismi, mail adresi ve şifre belirlemesini isteyerek HomeController ekranına geçişini sağlıyorum.
Kullanıcı daha önce Register olmuşsa ve tekrar uygulamaya giriş yapmak istiyorsa Login ekranına yönlediriyorum ve kullanıcı sadece mail adresi ve şifresi ile HomeController ekranına giriş yapabiliyor.


HomeController ekranına gelen kullanıcıya gerçek bir Tinder uygulaması simülasyonu yaşatmak için Firestore Database'de daha önce oluşturduğum kişi kartlarını Firebase'den çekerek kullanıcıya gösteriyorum.
Kullanıcı, Tinder uygulamasında olduğu gibi eşleşmek istediği kişi kartını sağa, istemediği kişi kartlarını sola atabiliyor. sağa attığı kişi kartları ile karşılıklı eşleşen kullanıcının mesaj kutusunda sağa sürüklediği ve karşılıklı eşleştiği kişi ile sohbet balonu açılıyor.
Kullanıcıya, eşleştiği ve oluşan sohbet balonundan seçtiği kişi ile başlattığı/devam eden sohbetleri yeni bir liste ile göstererek, başlamış ve başlamamış sohbetleri ayırıyorum.


Register ekranındaki seçtiği profil fotoğrafını değiştirmek, yeni fotolar eklemek isteyen kullanıcı için Tinder uygulamasındaki gibi bir profil sayfası oluşturdum ve burada kullanıcının yaş bilgilerini, meslek bilgilerini girmesini sağlayarak sonraki girişlerinde bilgilerinin kaybolmaması için Firestora Database'de sakladım.


Bu proje kapsamında aşağıdaki Swift özelliklerini kullanarak geliştirme yaptım:

<br/>**UIKit**
<br/>**ProgramaticUI**
<br/>**MVVM Architecture**
<br/>**Swift Bindable**
<br/>**Firebase & Firestore Database**
<br/>**Swift UI PanGesture Recognizer Animations**
<br/>**Swift keyframe animation**
<br/>**Resolving Retain Cycles**
<br/>**Pagination Data Fetch**
<br/>**Swift Reactive Programing**
<br/>**Swift AutoLayout**
<br/>**Dependency Injection**

<img width="200" alt="![tinderrr]" src="https://github.com/turancabuk/Tinder/assets/98350672/eb95e847-c775-4eb6-a2b2-55e8e4a24a60">
<img width="200" alt="![ekran resmi]" src="https://github.com/turancabuk/Tinder/assets/98350672/ac71b35f-faff-4188-9469-f96935262d55">
<img width="200" alt="![ekran resmi1]" src="https://github.com/turancabuk/Tinder/assets/98350672/79acee69-9bba-4bf0-9a43-8dc95fe8a281">
<img width="200" alt="![ekran resmi2]" src="https://github.com/turancabuk/Tinder/assets/98350672/eb113f78-683d-4d8a-a73a-aa2534c27b0f">




This project is an app clone based on the Tinder social media app. During this study period, I took my iOS development skills to the highest level by using the advanced features of the Swift programming language.

When the application is run, on the Register screen shown to the user, I ask the user to specify a profile photo, user name, e-mail address and password, allowing the user to switch to the HomeController screen.
If the user has been registered before and wants to log in to the application again, I am directed to the Login screen and the user can log in to the HomeController screen with only his e-mail address and password.


In order to provide a real Tinder application simulation to the user who comes to the HomeController screen, I pull the contact cards I previously created in the Firestore Database from Firebase and show them to the user.
Just like in the Tinder application, the user can throw the card of the person he wants to match with to the right, and the cards of the person he does not want to match to the left. A chat bubble opens with the person the user drags to the right and matches with the person they matched with in the message box.
I separate the chats that have started and those that have not started by showing the user a new list of the chats that he started/ongoing with the person he matched with and selected from the chat bubble.


I created a profile page like in the Tinder application for the user who wants to change the profile photo he/she has selected on the Register screen and add new photos. Here, I allowed the user to enter his/her age information and occupation information and stored it in the Firestora Database so that the information is not lost in subsequent logins.


Within the scope of this project, I developed using the above Swift features.
