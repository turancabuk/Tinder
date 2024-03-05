
# Appstore Clone


Bu proje, Tinder sosyal medya uygulaması temel alınarak geliştirilmiş bir uygulama klonudur. Bu çalışma sürecinde, Swift programlama dilinin gelişmiş özelliklerini kullanarak iOS geliştirme yeteneklerimi en ileri seviyeye taşıdım.

Uygulama çalıştırıldığında, kullanıcıya gösterilen Register ekranında, kullanıcıdan bir profil fotoğrafı, kullanıcı ismi, mail adresi ve şifre belirlemesini isteyerek HomeController ekranına geçişini sağlıyorum.
Kullanıcı daha önce Register olmuşsa ve tekrar uygulamaya giriş yapmak istiyorsa Login ekranına yönlediriyorum ve kullanıcı sadece mail adresi ve şifresi ile HomeController ekranına giriş yapabiliyor.


HomeController ekranına gelen kullanıcıya gerçek bir Tinder uygulaması simülasyonu yaşatmak için Firestore Database'de daha önce oluşturduğum kişi kartlarını Firebase'den çekerek kullanıcıya gösteriyorum.
Kullanıcı, Tinder uygulamasında olduğu gibi eşleşmek istediği kişi kartını sağa, istemediği kişi kartlarını sola atabiliyor. sağa attığı kişi kartları ile karşılıklı eşleşen kullanıcının mesaj kutusunda sağa sürüklediği ve karşılıklı eşleştiği kişi ile sohbet balonu açılıyor.
Kullanıcıya, eşleştiği ve oluşan sohbet balonundan seçtiği kişi ile başlattığı/devam eden sohbetleri yeni bir liste ile göstererek, başlamış ve başlamamış sohbetleri ayırıyorum.


Register ekranındaki seçtiği profil fotoğrafını değiştirmek, yeni fotolar eklemek isteyen kullanıcı için Tinder uygulamasındaki gibi bir profil sayfası oluşturdum ve burada kullanıcının yaş bilgilerini, meslek bilgilerini girmesini sağlayarak sonraki girişlerinde bilgilerinin kaybolmaması için Firestora Database'de sakladım.


Bu proje kapsamında aşağıdaki Swift özelliklerini kullanarak geliştirme yaptım:

<br/>**UIKit**
<br/>**Firebase & Firestore Database**
<br/>**MVVM Architecture**
<br/>**Swift Bindable**
<br/>**Swift UI PanGesture Recognizer**
<br/>**Resolving Retain Cycles**
<br/>**Swift keyframe animation**
<br/>**Swift Reactive Programing**
<br/>**ProgramaticUI**
<br/>**Swift AutoLayout**
<br/>**Pagination Data Fetch**
<br/>**Dependency Injection**

This project is a replica of Apple's App Store, developed as a mobile application store clone. Throughout this process, I enhanced my iOS development skills by utilizing advanced features of the Swift programming language.

Using API endpoints obtained from "https://rss.applemarketingtools.com", the application categorizes apps similarly to the App Store, organizing them within the Today, Search, Apps, and Musics tabs to provide users with a categorized and easily accessible list.

This endeavor aims to push my iOS app development skills to the forefront and leverage the latest features offered by Swift. You can explore this repository to understand and implement features that you can use in your own projects.

In this project I implemented the above Swift features.
