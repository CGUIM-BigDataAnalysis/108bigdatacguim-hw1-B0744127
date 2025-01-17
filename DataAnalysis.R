library(jsonlite)
library(dplyr)
library(readr)

Data107 <- read_csv("C:\\Users\\Candy\\Desktop\\107.csv")
Data104 <- read_csv("http://ipgod.nchc.org.tw/dataset/b6f36b72-0c4a-4b60-9254-1904e180ddb1/resource/98d5094d-7481-44b5-876a-715a496f922c/download/a17000000j-020066-mah.csv")
Data104$大職業別 <- gsub("部門","", Data104$大職業別)
Data104$大職業別 <- gsub("、","_", Data104$大職業別)
Data104$大職業別 <- gsub("教育服務業","教育業", Data104$大職業別)
Data104$大職業別 <- gsub("營造業","營建工程", Data104$大職業別)
Data104$大職業別 <- gsub("醫療保健服務業","醫療保健業", Data104$大職業別)
Data104$大職業別 <- gsub("資訊及通訊傳播業","出版、影音製作、傳播及資通訊服務業", Data104$大職業別)
Data104$`大學-薪資` <- gsub("—|…"," ", Data104$`大學-薪資`)
Data107$`大學-薪資` <- gsub("—|…"," ", Data107$`大學-薪資`)
Data104$`大學-女/男` <- gsub("—|…"," ", Data104$`大學-女/男`)
Data107$`大學-女/男` <- gsub("—|…"," ", Data107$`大學-女/男`)
Data104$`研究所及以上-薪資` <- gsub("—"," ", Data104$`研究所及以上-薪資`)
Data107$`研究所-薪資` <- gsub("—|…"," ", Data107$`研究所-薪資`)
Data107$`研究所-薪資` <- as.numeric(Data107$`研究所-薪資`)
Data107$`大學-薪資` <- as.numeric(Data107$`大學-薪資`)
JoinData <- merge(Data104,Data107,by="大職業別",all=T)
JoinData$`大學-薪資.x` <- as.numeric(JoinData$`大學-薪資.x`)
JoinData$`大學-薪資.y` <- as.numeric(JoinData$`大學-薪資.y`)

JoinData$大學薪資提高比 <- JoinData$`大學-薪資.x`/JoinData$`大學-薪資.y` # 算薪資提高率
HigherThan104 <- filter(JoinData, 大學薪資提高比>1) #107年度薪資較104年度薪資高
order <- HigherThan104 %>%    #107年度薪資較104年度薪資高的職業
  arrange(desc(大學薪資提高比)) %>% 
  pull(大職業別)

First10 <- head(JoinData[order(JoinData$大學薪資提高比,decreasing = T),], 10) #薪資提高率取前10

Hight_Rate <- filter(JoinData, 大學薪資提高比>1.05) #薪資提高率超過5% 
Hight_Rate[ , 1]
table(Hight_Rate[ , 1])

F_M_104_dec <- Data104 %>%    #104年大學畢業男女薪資比例由大到小
  arrange(desc((as.numeric(`大學-女/男`)))) 
F_M_107_dec <- Data107 %>%    #107年大學畢業男女薪資比例由大到小
  arrange(desc(as.numeric(`大學-女/男`))) 
F_M_104_inc <- Data104 %>%    #104年大學畢業男女薪資比例由小到大
  arrange((as.numeric(`大學-女/男`)))
F_M_107_inc <- Data107 %>%    #107年大學畢業男女薪資比例由小到大
  arrange((as.numeric(`大學-女/男`)))
head(F_M_104_inc[, 2], 10) #104男生薪資比女生多 前10名
head(F_M_107_inc[, 2], 10) #107男生薪資比女生多 前10名
head(F_M_104_dec[, 2], 10) #104女生薪資比女生多 前10名
head(F_M_107_dec[, 2], 10) #107女生薪資比女生多 前10名


Data107$`研究所/大學薪資` <- Data107$`研究所-薪資`/Data107$`大學-薪資` #新增研究所/大學薪資
Gra_Uni_dec <- Data107 %>%    #107年研究所/大學薪資比例由大到小
  arrange(desc((`研究所/大學薪資`)))
head(Gra_Uni_dec[, 2], 10) #呈現前10名職業名稱

Ind_Col_104 <- Data104[3, 11]
Ind_Col_107 <- Data107[3, 11]
Ind_Gra_104 <- Data104[3, 13]
Ind_Gra_107 <- Data107[3, 13]
Inf_Col_104 <- Data104[78, 11]
Inf_Col_107 <- Data107[78, 11]
Inf_Gra_104 <- Data104[78, 13]
Inf_Gra_107 <- Data107[78, 13]

diff_Ind_104 <- as.numeric(Ind_Gra_104)-as.numeric(Ind_Col_104)
diff_Ind_107 <- as.numeric(Ind_Gra_107)-as.numeric(Ind_Col_107)
diff_Inf_104 <- as.numeric(Inf_Gra_104)-as.numeric(Inf_Col_104)
diff_Inf_107 <- as.numeric(Inf_Gra_107)-as.numeric(Inf_Col_107)

as.numeric(Data104[3, 13])-as.numeric(Data104[3, 11]) #104工業及服務業研究所大學薪資差
as.numeric(Data107[3, 13])-as.numeric(Data107[3, 11]) #107工業及服務業研究所大學薪資差
as.numeric(Data104[78, 13])-as.numeric(Data104[78, 11]) #104資通業研究所大學薪資差
as.numeric(Data107[78, 13])-as.numeric(Data107[78, 11]) #107資通業研究所大學薪資差
