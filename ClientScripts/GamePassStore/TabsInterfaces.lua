-- when the button is activated all the interfaces in the store are closed and this interface is opened
--Exists 6 or 7 scripts like that in my gui so i will not put them separated so i will put just two because the other scripts are just copy 
--1
local botao = script.Parent

botao.Activated:Connect(function(hit)
	botao.Parent.Visible = false
	botao.Parent.Parent.InterfaceSecundaria.Visible = true
end)

--2
local botao = script.Parent

botao.Activated:Connect(function(hit)
	botao.Parent.Visible = false
	botao.Parent.Parent.InterfaceTerciaria.Visible = true
end)
