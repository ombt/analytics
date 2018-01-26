library(networkD3)

world <- list(name="World", children=list(
  
  list(name="America", children = list(
    list(name="Argentina"),
    list(name="Brazil"),
    list(name="Uruguay")
  )),
  list(name="Africa", children = list(
    list(name="Benin"),
    list(name="Argelia"),
    list(name="South Africa")
  )),
  list(name="Europe", children = list(
    list(name="Germany"),
    list(name="Italy"),
    list(name="Spain")
  )),
  list(name="Asia", children = list(
    list(name="Japan"),
    list(name="China"),
    list(name="India")
  ))
))
