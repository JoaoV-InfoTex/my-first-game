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
