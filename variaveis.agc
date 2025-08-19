// =============================
// Variáveis principais
// =============================
pontuacao = 0
estado = 0 // 0 = menu, 1 = jogando, 2 = game over

#constant QUANTIDADE 4
#constant ALTURA_CARRO 100
#constant DISTANCIA_MINIMA 120

Dim carroID[QUANTIDADE]
Dim tiroID[QUANTIDADE]
Dim tiroAtivo[QUANTIDADE]
Dim tiroDisparado[QUANTIDADE]
Dim tiroX#[QUANTIDADE]
Dim tiroY#[QUANTIDADE]
Dim posicoesYUsadas[QUANTIDADE]

velocidadeBaseCarro# = 350.0
velocidadeTiro# = 800.0
speed# = 200.0
tempoUltimoPonto# = Timer()

menuTextID = CreateText("Pressione ENTER para começar")
SetTextSize(menuTextID, 40)
SetTextAlignment(menuTextID, 1)
SetTextPosition(menuTextID, 512, 304)

gameOverTextID = CreateText("GAME OVER - ENTER para Menu - R para sair")
SetTextSize(gameOverTextID, 30)
SetTextAlignment(gameOverTextID, 1)
SetTextPosition(gameOverTextID, 512, 304)
SetTextVisible(gameOverTextID, 0)
