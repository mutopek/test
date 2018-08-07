library(httr)
library(openxlsx)
library (curl)
#wyznaczenie daty pocz¹tkowej i koñcowej
dataSTART<-as.Date("2018-03-01")
dataEND<-as.Date(Sys.Date())
#wprowadzenie wektora z datami od pocz¹tku do koñca zadanego okresu
dataVECTOR=seq(from=dataSTART, to=dataEND, by="day")
#utworzenie wektora z nazwami miesiêcy po angielsku
month = c("January","February","March","April","May","June","July","August","September","October","November","December")

i<-1

while (i <= length(dataVECTOR)) {
  
  
  #tworzenie zmiennych zwi¹zanych z dat¹ i wprowadzenie ich do adresu url
  miesiac<-format(dataVECTOR[i]-1, "%m")
  m<-format(dataVECTOR[i], "%m")
  rok<-format(dataVECTOR[i]-1,"%Y")
  r<-format(dataVECTOR[i],"%Y")
  dzien<-format(dataVECTOR[i]-1,"%d")
  d<-format(dataVECTOR[i],"%d")
  
  url=(sprintf("https://tge.pl/fm/upload/WYNIKI-SESJI/RDNg/%s-%s/Raport_publiczny_RDNG_%s_%s_%s.xlsx",month[as.numeric(format(dataVECTOR[i], "%m"))],rok,rok,miesiac,dzien))
  
  #tworzenie œcie¿ki zapisu plików
  sciezka=paste0(as.character(r),"/RDB_",as.character(r),as.character(m),as.character(d),".csv")
  #sprawdzanie b³êdu 1-go dnia miesi¹ca
  mies<-as.numeric(format(dataVECTOR[i]-1, "%m"))
  if ((dzien==30 ||dzien==31) & mies <= 5){
    url=(sprintf("https://tge.pl/fm/upload/WYNIKI-SESJI/RDNg/%s-%s/Raport_publiczny_RDNG_%s_%s_%s.xlsx",month[as.numeric(format(dataVECTOR[i]-1, "%m"))],rok,rok,miesiac,dzien))
  }
 #tworzenie katalogów
  if (isFALSE(dir.exists(paths = as.character(r)))){
    dir.create(as.character(r))
  }
    
  #wczytywanie danych z pliku z sieci (jeœli nie istnieje) oraz dodawanie dat i nazw kolumn
  if (isFALSE(file.exists(sciezka))){
    indeks<-as.data.frame(read.xlsx(url ,sheet = "GAS",rows = 12,cols=3, colNames=FALSE, rowNames = FALSE))
    indeks<-cbind(dataVECTOR[i],indeks)
    colnames(indeks)<-c("data","cena")
    #zapisywanie danych w pliku
    write.table(x = indeks, file=sciezka, append = FALSE, row.names = FALSE,sep = ";",col.names = TRUE)
  }
  i=i+1
}
