local Chamados = {}

local Motivos = {
    "Problemas de conexao ou rede",
    "Erros de software",
    "Problemas de hardware",
    "Problemas com e-mail",
    "Virus ou malware",
    "Backup e recuperacao de dados"
}

local function LimparTerminal()
    if not os.execute("clear") then
        os.execute("cls")
    end
end

local function UltimoID()
    print(#Chamados)
    print(#Chamados > 0 and Chamados[#Chamados].ID or "")
    return #Chamados > 0 and Chamados[#Chamados].ID or 0
end

local function NovoChamado ()
    LimparTerminal()

    io.write("Qual o nome do chamado? > ")
    local Nome = io.read()

    io.write([[

1 - Problemas de conexao ou rede
2 - Erros de software
3 - Problemas de hardware
4 - Problemas com e-mail
5 - Virus ou malware
6 - Backup e recuperacao de dados
7 - Outro
Qual o motivo do chamado? > ]])
    local Index = tonumber(io.read())
    local Motivo

    if not Index or Index > 6 or Index < 1 or math.floor(Index) ~= Index then
        Motivo = "Outro"
    else
        Motivo = Motivos[Index]
    end

    io.write("\nPor favor, explique o problema em detalhes > ")
    local Descricao = io.read()

    local ID = UltimoID() + 1
    table.insert(Chamados, {
        Nome = Nome,
        Motivo = Motivo,
        Descricao = Descricao,
        ID = ID,
        Resolvido = false,
        Prioridade = 0
    })
end

local function BuscarChamado(SelecionarChamado)
    while true do
        LimparTerminal()

        io.write([[
1 - Nome
2 - Descricao
3 - ID
Como deseja buscar os chamados? > ]])

        local Opcao = tonumber(io.read())

        if Opcao == 1 then
            io.write("Digite o nome > ")
            local Valor = string.lower(io.read())

            print("Resultados: ")
            local Resultados = {}
            for _, Info in ipairs(Chamados) do
                local Nome = string.lower(Info.Nome)
                if string.match(Nome, Valor) then
                    print(Info.ID.." - "..Info.Nome)
                    print("-> "..Info.Descricao)
                    table.insert(Resultados, Info)
                end
            end

            if SelecionarChamado and #Resultados > 0 then
                while true do
                    io.write("Selecione um dos chamados > ")
                    local Opcao = tonumber(io.read())

                    for _, Info in ipairs(Resultados) do
                        if Info.ID == Opcao then
                            return Info
                        end
                    end

                    print("Chamado invalido.")
                end
            else
                io.write("Pressione enter para voltar. ")
                if io.read() then
                    return
                end
            end
        elseif Opcao == 2 then
            io.write("Digite a descricao > ")
            local Valor = io.read()

            print("Resultados: ")
            local Resultados = {}
            for _, Info in ipairs(Chamados) do
                local Descricao = string.lower(Info.Descricao)
                if string.match(Descricao, Valor) then
                    print(Info.ID.." - "..Info.Nome)
                    print("-> "..Info.Descricao)
                    table.insert(Resultados, Info)
                end
            end

            if SelecionarChamado and #Resultados > 0 then
                while true do
                    io.write("Selecione um dos chamados > ")
                    local Opcao = tonumber(io.read())

                    for _, Info in ipairs(Resultados) do
                        if Info.ID == Opcao then
                            return Info
                        end
                    end

                    print("Chamado invalido.")
                end
            else
                io.write("Pressione enter para voltar. ")
                if io.read() then
                    return
                end
            end
        elseif Opcao == 3 then
            io.write("Digite o ID > ")
            local Valor = tonumber(io.read())

            print("Resultados: ")
            for _, Info in ipairs(Chamados) do
                if Info.ID == Valor then
                    print(Info.ID.." - "..Info.Nome)
                    print("-> "..Info.Descricao)
                    
                    if SelecionarChamado then
                        return Info
                    end
                end
            end

            io.write("Pressione enter para voltar. ")
            if io.read() then
                return
            end
        end
    end
end

local function FinalizarChamado()
    local Chamado = BuscarChamado(true)
    LimparTerminal()

    if Chamado then
        if not Chamado.Resolvido then
            Chamado.Resolvido = true
            print("O chamado \""..Chamado.Nome.."\" foi finalizado.")
        else
            print("O chamado \""..Chamado.Nome.."\" ja estava finalizado.")
        end
    else
        print("Chamado nao encontrado.")
    end

    io.write("Pressione enter para voltar. ")
    if io.read() then
        return
    end
end

local function MudarPrioridade()
    local Chamado = BuscarChamado(true)
    LimparTerminal()

    if Chamado then
        while true do
            LimparTerminal()

            io.write("Qual sera a nova prioridade? > ")
            local Prioridade = tonumber(io.read())
            if Prioridade then
                Chamado.Prioridade = Prioridade
                print("Prioridade alterada com sucesso!")
                break
            end
        end
    else
        print("Chamado nao encontrado.")
    end

    io.write("Pressione enter para voltar. ")
    if io.read() then
        return
    end
end

local function OrdenarChamados(MenorAteMaior)
    LimparTerminal()

    local Clone = {}
    for _, Info in ipairs(Chamados) do
        table.insert(Clone, Info)
    end

    table.sort(Clone, function(A, B)
        if A.Prioridade == B.Prioridade then
            if MenorAteMaior then
                return A.ID < B.ID
            else
                return A.ID > B.ID
            end
        end

        if MenorAteMaior then
            return A.Prioridade < B.Prioridade
        else
            return A.Prioridade > B.Prioridade
        end
    end)

    for _, Info in ipairs(Clone) do
        print("["..Info.Prioridade.."] "..Info.ID.." - "..Info.Nome)
        print("-> "..Info.Descricao)
    end

    if #Clone <= 0 then
        print("Nenhum chamado registrado.")
    end

    io.write("Pressione enter para voltar. ")
    if io.read() then
        return
    end
end

local function Prioridades()
    while true do
        LimparTerminal()

        io.write([[
~ PRIORIDADES ~
1 - Mudar prioridade de um chamado
2 - Listar chamados da menor prioridade ate a maior
3 - Listar chamados da maior prioridade ate a menor
4 - Voltar ao menu principal
O que deseja fazer? > ]])

        local Opcao = tonumber(io.read())
        if Opcao == 1 then
            MudarPrioridade()
        elseif Opcao == 2 then
            OrdenarChamados(true)
        elseif Opcao == 3 then
            OrdenarChamados(false)
        elseif Opcao == 4 then
            return
        end
    end
end

local function Estatisticas()
    local Total = #Chamados
    local Finalizados = 0
    local NaoFinalizados = 0

    for _, Info in ipairs(Chamados) do
        if Info.Resolvido then
            Finalizados = Finalizados + 1
        else
            NaoFinalizados = NaoFinalizados + 1
        end
    end

    print("~ CONTAGEM ~")
    print("Chamados totais: "..Total)
    print("Chamados finalizados: "..Finalizados)
    print("Chamados nao finalizados: "..NaoFinalizados)

    print("\n~ PERCENTUAL ~")
    print("Chamados finalizados: "..(Finalizados / Total * 100))
    print("Chamados nao finalizados: "..(NaoFinalizados / Total * 100))

    io.write("Pressione enter para voltar. ")
    if io.read() then
        return
    end
end

local function LimparFinalizados()
    LimparTerminal()
    io.write("Tem certeza que deseja remover TODOS os chamados FINALIZADOS? Digite \"Tenho certeza\" para confirmar. > ")

    local Resposta = io.read()
    if Resposta == "Tenho certeza" then
        local Removidos = {}
        for Index = #Chamados, 1, -1 do
            local Info = Chamados[Index]
            if Info.Resolvido then
                table.remove(Chamados, Index)
                table.insert(Removidos, Info.Nome)
            end
        end

        if #Removidos > 0 then
            print("Os chamados removidos foram: "..table.concat(Removidos, ", "))
        else
            print("Nao tem nenhum chamado finalizado.")
        end

        io.write("Pressione enter para voltar. ")
        if io.read() then
            return
        end
    else
        while true do
            LimparTerminal()
            io.write([[
~ LIMPEZA ABORTADA ~
1 - Tentar novamente
2 - Voltar
]])

            local Opcao = tonumber(io.read())
            if Opcao == 1 then
                return LimparFinalizados()
            else
                return
            end
        end
    end
end

local function LimparTodos()
    LimparTerminal()
    io.write("Tem certeza que deseja remover TODOS os chamados? Digite \"Tenho certeza\" para confirmar. > ")

    local Resposta = io.read()
    if Resposta == "Tenho certeza" then
        for Index = #Chamados, 1, -1 do
            table.remove(Chamados, Index)
        end
    
        print("Todos os chamados foram removidos.")

        io.write("Pressione enter para voltar. ")
        if io.read() then
            return
        end
    else
        while true do
            LimparTerminal()
            io.write([[
~ LIMPEZA ABORTADA ~
1 - Tentar novamente
2 - Voltar
]])

            local Opcao = tonumber(io.read())
            if Opcao == 1 then
                return LimparTodos()
            else
                return
            end
        end
    end
end

local function LimparLista()
    while true do
        LimparTerminal()

        io.write([[
~ LIMPAR LISTA ~
1 - Limpar chamados finalizados
2 - Limpar todos os chamados
3 - Voltar ao menu principal
O que deseja fazer? > ]])

        local Opcao = tonumber(io.read())
        if Opcao == 1 then
            LimparFinalizados()
        elseif Opcao == 2 then
            LimparTodos()
        elseif Opcao == 3 then
            return
        end
    end
end

local function Menu()
    while true do
        LimparTerminal()
        
        io.write([[
~ SUPORTE TECNICO ~
1 - Registrar chamado
2 - Buscar chamado
3 - Finalizar chamado
4 - Prioridades
5 - Estatisticas
6 - Limpeza
7 - Sair
O que deseja fazer? > ]])

        local Opcao = tonumber(io.read())
        if Opcao == 1 then
            NovoChamado()
        elseif Opcao == 2 then
            BuscarChamado(false)
        elseif Opcao == 3 then
            FinalizarChamado()
        elseif Opcao == 4 then
            Prioridades()
        elseif Opcao == 5 then
            Estatisticas()
        elseif Opcao == 6 then
            LimparLista()
        elseif Opcao == 7 then
            return
        end
    end
end

Menu()
