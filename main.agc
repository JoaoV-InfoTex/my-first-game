// =============================
// CYBERRUN com Menu, Game Over e Música
// =============================

// Configurações iniciais
SetErrorMode(2)
SetWindowTitle("cyberRUN")
SetWindowSize(1480, 780, 0)
SetWindowAllowResize(1)
SetVirtualResolution(1024, 768)
SetSyncRate(60, 1)
UseNewDefaultFonts(1)

// =============================
// Carregar imagens e música
// =============================
LoadImage(1, "fundo.png")
LoadImage(2, "Cypher.png")
LoadImage(3, "police.png")
LoadImage(4, "tiro.png")
LoadMusicOGG(1, "musica.ogg")
PlayMusicOgg(1, 1)

// =============================
// Criar sprites iniciais
// =============================
CreateSprite(1, 1) // fundo
SetSpritePosition(1, 0, 0)
SetSpriteSize(1, 1024, 768)

CreateSprite(2, 2) // jogador
SetSpriteSize(2, 100, 100)
SetSpritePosition(2, 100, 300)

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

// =============================
// Criar textos fixos
// =============================
menuTextID = CreateText("Pressione ENTER para começar")
SetTextSize(menuTextID, 40)
SetTextAlignment(menuTextID, 1)
SetTextPosition(menuTextID, 512, 304)

gameOverTextID = CreateText("GAME OVER - ENTER para Menu - R para sair")
SetTextSize(gameOverTextID, 30)
SetTextAlignment(gameOverTextID, 1)
SetTextPosition(gameOverTextID, 512, 304)
SetTextVisible(gameOverTextID, 0)

// =============================
// Funções auxiliares
// =============================

// Gerar posição Y com distância mínima
function GerarPosicaoYComDistancia()
    local y#, valido, i
    do
        valido = 1
        y# = Random(0, 768 - ALTURA_CARRO)
        for i = 0 to QUANTIDADE - 1
            if abs(y# - posicoesYUsadas[i]) < DISTANCIA_MINIMA
                valido = 0
            endif
        next i
        if valido = 1 then exit
    loop
endfunction y#

// Colisão com margem (inset)
function ColisaoRetangularInset(x1#, y1#, w1#, h1#, x2#, y2#, w2#, h2#, inset#)
    x1# = x1# + inset#
    y1# = y1# + inset#
    w1# = w1# - inset# * 2
    h1# = h1# - inset# * 2

    x2# = x2# + inset#
    y2# = y2# + inset#
    w2# = w2# - inset# * 2
    h2# = h2# - inset# * 2

    resultado = 0
    if x1# < x2# + w2#
        if x1# + w1# > x2#
            if y1# < y2# + h2#
                if y1# + h1# > y2#
                    resultado = 1
                endif
            endif
        endif
    endif
endfunction resultado

// Resetar jogo
function ResetarJogo()
    pontuacao = 0
    tempoUltimoPonto# = Timer()
    SetSpritePosition(2, 100, 300)

    for i = 0 to QUANTIDADE - 1
        posicoesYUsadas[i] = -9999
    next i

    for i = 0 to QUANTIDADE - 1
        posicoesYUsadas[i] = GerarPosicaoYComDistancia()
        SetSpritePosition(carroID[i], 1024 + i * 300, posicoesYUsadas[i])
        tiroDisparado[i] = 0
        tiroAtivo[i] = 0
        SetSpriteVisible(tiroID[i], 0)
    next i
endfunction

// =============================
// Criar carros e tiros
// =============================
for i = 0 to QUANTIDADE - 1
    carroID[i] = CreateSprite(3)
    posicoesYUsadas[i] = GerarPosicaoYComDistancia()
    SetSpritePosition(carroID[i], 1024 + i * 300, posicoesYUsadas[i])
    SetSpriteSize(carroID[i], 240, 150)

    tiroID[i] = CreateSprite(4)
    SetSpriteVisible(tiroID[i], 0)
    SetSpriteSize(tiroID[i], 60, 20)

    tiroAtivo[i] = 0
    tiroDisparado[i] = 0
next i

// =============================
// Loop principal
// =============================
do
    frameTime# = GetFrameTime()

    // MENU
    if estado = 0
        SetTextVisible(menuTextID, 1)
        SetTextVisible(gameOverTextID, 0)
        if GetRawKeyPressed(13) // ENTER
            estado = 1
            ResetarJogo()
            SetTextVisible(menuTextID, 0)
        endif
        Sync()
        continue
    endif

    // GAME OVER
    if estado = 2
        SetTextVisible(gameOverTextID, 1)
        if GetRawKeyPressed(13) // ENTER
            estado = 0
        endif
        if GetRawKeyPressed(82) // R
            End
        endif
        Sync()
        continue
    endif

    // JOGO
    if estado = 1
        // Movimento jogador
        x# = GetSpriteX(2)
        y# = GetSpriteY(2)

        if GetRawKeyState(87) then y# = y# - speed# * frameTime#
        if GetRawKeyState(83) then y# = y# + speed# * frameTime#
        if GetRawKeyState(65) then x# = x# - speed# * frameTime#
        if GetRawKeyState(68) then x# = x# + speed# * frameTime#

        if x# < 0 then x# = 0
        if x# > 1024 - GetSpriteWidth(2) then x# = 1024 - GetSpriteWidth(2)
        if y# < 0 then y# = 0
        if y# > 768 - GetSpriteHeight(2) then y# = 768 - GetSpriteHeight(2)

        SetSpritePosition(2, x#, y#)

        // Movimento carros e tiros
        for i = 0 to QUANTIDADE - 1
            cx# = GetSpriteX(carroID[i])
            cy# = GetSpriteY(carroID[i])

            velocidadeCarroAtual# = velocidadeBaseCarro# + (pontuacao / 50.0)
            cx# = cx# - velocidadeCarroAtual# * frameTime#
            SetSpritePosition(carroID[i], cx#, cy#)

            if cx# <= 800 and tiroDisparado[i] = 0
                tiroAtivo[i] = 1
                tiroDisparado[i] = 1
                tiroX#[i] = cx#
                tiroY#[i] = cy# + GetSpriteHeight(carroID[i]) / 2 - GetSpriteHeight(tiroID[i]) / 2
                SetSpritePosition(tiroID[i], tiroX#[i], tiroY#[i])
                SetSpriteVisible(tiroID[i], 1)
            endif

            if tiroAtivo[i] = 1
                tiroX#[i] = tiroX#[i] - velocidadeTiro# * frameTime#
                SetSpritePosition(tiroID[i], tiroX#[i], tiroY#[i])
                if tiroX#[i] < -GetSpriteWidth(tiroID[i])
                    SetSpriteVisible(tiroID[i], 0)
                    tiroAtivo[i] = 0
                endif
            endif

            if cx# < -GetSpriteWidth(carroID[i])
                cx# = 1024 + i * 200
                posicoesYUsadas[i] = GerarPosicaoYComDistancia()
                SetSpritePosition(carroID[i], cx#, posicoesYUsadas[i])
                tiroDisparado[i] = 0
                pontuacao = pontuacao + 1
            endif
        next i

        // Colisões
        px# = GetSpriteX(2)
        py# = GetSpriteY(2)
        pw# = GetSpriteWidth(2)
        ph# = GetSpriteHeight(2)

        for i = 0 to QUANTIDADE - 1
            cx# = GetSpriteX(carroID[i])
            cy# = GetSpriteY(carroID[i])
            cw# = GetSpriteWidth(carroID[i])
            ch# = GetSpriteHeight(carroID[i])

            if ColisaoRetangularInset(px#, py#, pw#, ph#, cx#, cy#, cw#, ch#, 10)
                estado = 2
          pontuacao = 0
			endif


            if tiroAtivo[i] = 1
                if ColisaoRetangularInset(px#, py#, pw#, ph#, tiroX#[i], tiroY#[i], GetSpriteWidth(tiroID[i]), GetSpriteHeight(tiroID[i]), 5)
                    estado = 2
					pontuacao = 0
				endif

            endif
        next i

        // Pontuação automática
        if Timer() - tempoUltimoPonto# > 100
            pontuacao = pontuacao + 1
            tempoUltimoPonto# = Timer()
        endif

        Print(ScreenFPS())
        Print("Pontuação: " + str(pontuacao))
    endif

    Sync()
loop
