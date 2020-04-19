-- title:	life
-- author:	pke1029
-- desc:	Game of life, LD46 entry, tribute to John Conway
-- script:	lua

-- music by Tiziana Comito 

-- source code available here:
-- https://github.com/pke1029/tic-life

life = {

    x = 105,
    y = 1,
    u = {},
    w = 4,
    h = 4, 
    Nx = 27,
    Ny = 27,
    padding = 1,
    on_col = 15,
    off_col = 0,
    t1 = 0,
    t2 = 0,
    interval = 500,
    speed = 1,
    waiting = true,
    pause = false,

    load = function(self)

        self:load_mat(13, 13, self.mat[1])

    end,

    tick = function(self)

        local v = {}    
        local i, j, im1, ip1, jm1, jp1, val, uij
        
        for i = 0,self.Nx-1 do

            if i == 0 then im1 = self.Nx-1 else im1 = i-1 end
            if i == self.Nx-1 then ip1 = 0 else ip1 = i+1 end
            
            for j = 0,self.Ny-1 do

                if j == 0 then jm1 = self.Ny-1 else jm1 = j-1 end
                if j == self.Ny-1 then jp1 = 0 else jp1 = j+1 end

                val = 0
                -- trace(im1*self.Ny+jm1+1)
                val = val + self.u[im1+jm1*self.Nx+1]
                val = val + self.u[im1+j*self.Nx+1]
                val = val + self.u[im1+jp1*self.Nx+1]
                val = val + self.u[i+jm1*self.Nx+1]
                val = val + self.u[i+jp1*self.Nx+1]
                val = val + self.u[ip1+jm1*self.Nx+1]
                val = val + self.u[ip1+j*self.Nx+1]
                val = val + self.u[ip1+jp1*self.Nx+1]

                uij = self.u[i+j*self.Nx+1]

                if uij == 1 and (val == 2 or val == 3) then
                    v[i+j*self.Nx+1] = 1
                elseif uij == 0 and val == 3 then
                    v[i+j*self.Nx+1] = 1
                else
                    v[i+j*self.Nx+1] = 0
                end

            end
        end

        return v

    end,

    draw = function(self)

        local i, j 
        
        for i = 0,self.Nx-1 do
            for j = 0,self.Ny-1 do
    
                uij = self.u[self.Nx*j+i+1]
    
                if uij == 1 then
                    rect(life.x + i*(life.w + life.padding), life.y+j*(life.h+life.padding), life.w, life.h, life.on_col)
                elseif uij == 0 then
                    rect(life.x + i*(life.w + life.padding), life.y+j*(life.h+life.padding), life.w, life.h, life.off_col)
                end
    
            end
        end
    
    end,

    interact = function(self)

        local x, y, left, middle, right = mouse()
        
        if left == true then

            local i = math.floor((x-life.x)/(life.w+life.padding))
            local j = math.floor((y-life.y)/(life.w+life.padding))
            
            if (between(i, 0, self.Nx) and between(j, 0, self.Ny)) then
                self.u[j*self.Nx+i+1] = 1
            end
        
        end

        if right == true then

            local i = math.floor((x-life.x)/(life.w+life.padding))
            local j = math.floor((y-life.y)/(life.w+life.padding))
            
            if (between(i, 0, self.Nx) and between(j, 0, self.Ny)) then
                self.u[j*self.Nx+i+1] = 0
            end

        end

    end, 

    timer = function()

        life.t2 = time()
        if life.t2 - life.t1 >= life.interval / life.speed then
            life.t1 = life.t2
            life.waiting = false
        else
            life.waiting = true
        end
    
    end,

    check_pause = function()

        if keyp(48) then
            if life.pause then
                life.pause = false
            else
                life.pause = true
            end
        end

    end,

    update = function(self)

        life:interact()
        life.check_pause()
        life.timer()
        if not life.waiting and not life.pause then
            self.u = life:tick()
        end

    end,

    load_mat = function(self, x, y, mat)

        life.clear(self)
        local row = #mat
        local col = #mat[1]
        local offsetx = math.floor(col/2)
        local offsety = math.floor(row/2) 

        local i, j
        for j = 1,row do
            for i = 1,col do
                local a = (x+i-offsetx-1) % self.Nx
                local b = (y+j-offsety-1) % self.Ny 
                self.u[a+b*self.Nx+1] = mat[j][i]
            end
        end

    end,

    clear = function(self)

        self.u = {}
        local i

        for i = 1,self.Nx*self.Ny do
            table.insert(self.u, 0)
        end

    end,

    show_mat = function(mat, x, y)

        local row = #mat
        local col = #mat[1]
        local offsetx = math.floor(col/2)
        local offsety = math.floor(row/2)

        for j = 1,row do
            for i = 1,col do

                if mat[j][i] == 1 then
                    rect(x+(i-1-offsetx)*5, y+(j-1-offsety)*5, 4, 4, 15)
                elseif mat[j][i] == 0 then
                    rect(x+(i-1-offsetx)*5, y+(j-1-offsety)*5, 4, 4, 0)
                end

            end
        end

    end,


    mat = {

        -- R-pentomino
        {{0,1,1},
         {1,1,0},
         {0,1,0}},

        -- Diehard
        {{0,0,0,0,0,0,1,0},
         {1,1,0,0,0,0,0,0},
         {0,1,0,0,0,1,1,1}},

        -- Acorn
        {{0,1,0,0,0,0,0},
         {0,0,0,1,0,0,0},
         {1,1,0,0,1,1,1}},

        -- Pulsar
        {{0,0,1,1,1,0,0,0,1,1,1,0,0},
         {0,0,0,0,0,0,0,0,0,0,0,0,0},
         {1,0,0,0,0,1,0,1,0,0,0,0,1},
         {1,0,0,0,0,1,0,1,0,0,0,0,1},
         {1,0,0,0,0,1,0,1,0,0,0,0,1},
         {0,0,1,1,1,0,0,0,1,1,1,0,0},
         {0,0,0,0,0,0,0,0,0,0,0,0,0},
         {0,0,1,1,1,0,0,0,1,1,1,0,0},
         {1,0,0,0,0,1,0,1,0,0,0,0,1},
         {1,0,0,0,0,1,0,1,0,0,0,0,1},
         {1,0,0,0,0,1,0,1,0,0,0,0,1},
         {0,0,0,0,0,0,0,0,0,0,0,0,0},
         {0,0,1,1,1,0,0,0,1,1,1,0,0}},

        -- Penta-decathlon
        {{0,0,1,0,0,0,0,1,0,0},
         {1,1,0,1,1,1,1,0,1,1},
         {0,0,1,0,0,0,0,1,0,0}},

        -- Glider
        {{1,0,0},
         {0,0,1},
         {1,1,1}},

        -- Spaceship
        {{0,0,0,1,1,0},
         {1,1,1,0,1,1},
         {1,1,1,1,1,0},
         {0,1,1,1,0,0}}
    }

}


game = {

    mode = false,
    x = 3,
    y = 3,
    u = {},
    w = 4,
    h = 4,
    padding = 1,
    Nx = 47,
    Ny = 24,
    t1 = 0,
    t2 = 0,
    interval = 150,
    pause = false,
    on_col = 15,
    off_col = 0,

    load = function(self)

        music(1)
        self.mode = true
        life.load_mat(game, 37, 12, life.mat[ui.selection.current+1])
        self.particles:load()

    end,

    draw = function(self)

        local i, j 
        
        for i = 0,self.Nx-1 do
            for j = 0,self.Ny-1 do
    
                uij = self.u[self.Nx*j+i+1]
    
                if uij == 1 then
                    rect(self.x + i*(self.w+self.padding), self.y+j*(self.h+self.padding), self.w, self.h, self.on_col)
                elseif uij == 0 then
                    rect(self.x + i*(self.w+self.padding), self.y+j*(self.h+self.padding), self.w, self.h, self.off_col)
                end
    
            end
        end

        self.particles:draw()

        if not self.win_seq.show then
            self.bullet:draw()
            self.player:draw()
        end

        self.hud:draw()
    
        if self.death_seq.show then
            self.death_seq:draw()
        elseif self.win_seq.show then
            self.win_seq:draw()
        end
    
    end,

    timer = function(self)

        self.t2 = time()
        if self.t2 - self.t1 >= self.interval then
            self.t1 = self.t2
            self.waiting = false
        else
            self.waiting = true
        end
    
    end,

    unpause = function(self)

        if self.pause then self.pause = false end

    end,

    update = function(self)

        self:timer()

        if not self.pause then
            
            if not self.waiting then
                self.u = life.tick(game)
            end

            if not self.death_seq.show and not self.win_seq.show then
                self.bullet:update()
                self.player:update()
                self.hud:update()
            end

            self.particles:update()

        end

        if self.death_seq.show then
            self.death_seq:update()
        elseif self.win_seq.show then
            self.win_seq:update()
        end

    end,

    player = {

        i = 5,
        j = 11,
        dir = 3,
        col = 8,
        life = 3,

        load = function(self)

            self.i = 5
            self.j = 11
            self.dir = 3
            self.life = 3

        end,

        draw = function(self)

            local im1, ip1, jm1, jp1

            if i == 0 then im1 = game.Nx-1 else im1 = (self.i-1) % game.Nx end
            if i == game.Nx-1 then ip1 = 0 else ip1 = (self.i+1) % game.Nx end
            if j == 0 then jm1 = game.Ny-1 else jm1 = (self.j-1) % game.Ny end
            if j == game.Ny-1 then jp1 = 0 else jp1 = (self.j+1) % game.Ny end

            rect(game.x + self.i*(game.w+game.padding), game.y+self.j*(game.h+game.padding), game.w, game.h, self.col)
            rect(game.x + ip1*(game.w+game.padding), game.y+self.j*(game.h+game.padding), game.w, game.h, self.col)
            rect(game.x + im1*(game.w+game.padding), game.y+self.j*(game.h+game.padding), game.w, game.h, self.col)
            rect(game.x + self.i*(game.w+game.padding), game.y+jp1*(game.h+game.padding), game.w, game.h, self.col)
            rect(game.x + self.i*(game.w+game.padding), game.y+jm1*(game.h+game.padding), game.w, game.h, self.col)

            if self.dir == 3 then
                rect(game.x + im1*(game.w+game.padding), game.y+jp1*(game.h+game.padding), game.w, game.h, self.col)
                rect(game.x + im1*(game.w+game.padding), game.y+jm1*(game.h+game.padding), game.w, game.h, self.col)
                rect(game.x + im1*(game.w+game.padding), game.y+self.j*(game.h+game.padding), game.w, game.h, game.off_col)
            elseif self.dir == 2 then
                rect(game.x + ip1*(game.w+game.padding), game.y+jp1*(game.h+game.padding), game.w, game.h, self.col)
                rect(game.x + ip1*(game.w+game.padding), game.y+jm1*(game.h+game.padding), game.w, game.h, self.col)
                rect(game.x + ip1*(game.w+game.padding), game.y+self.j*(game.h+game.padding), game.w, game.h, game.off_col)
            elseif self.dir == 1 then
                rect(game.x + ip1*(game.w+game.padding), game.y+jm1*(game.h+game.padding), game.w, game.h, self.col)
                rect(game.x + im1*(game.w+game.padding), game.y+jm1*(game.h+game.padding), game.w, game.h, self.col)
                rect(game.x + self.i*(game.w+game.padding), game.y+jm1*(game.h+game.padding), game.w, game.h, game.off_col)
            elseif self.dir == 0 then
                rect(game.x + ip1*(game.w+game.padding), game.y+jp1*(game.h+game.padding), game.w, game.h, self.col)
                rect(game.x + im1*(game.w+game.padding), game.y+jp1*(game.h+game.padding), game.w, game.h, self.col)
                rect(game.x + self.i*(game.w+game.padding), game.y+jp1*(game.h+game.padding), game.w, game.h, game.off_col)
            end

        end,

        update = function(self)

            if btnp(0, 6, 6) then self.j = (self.j - 1) % game.Ny end
            if btnp(1, 6, 6) then self.j = (self.j + 1) % game.Ny end
            if btnp(2, 6, 6) then self.i = (self.i - 1) % game.Nx end
            if btnp(3, 6, 6) then self.i = (self.i + 1) % game.Nx end

            if btn(0) then self.dir = 0 end
            if btn(1) then self.dir = 1 end
            if btn(2) then self.dir = 2 end
            if btn(3) then self.dir = 3 end

            if self:collision() then
                game.death_seq:load()
            elseif self:win() then
                game.win_seq:load()
            end

        end,

        collision = function(self)

            local im1, ip1, jm1, jp1, val

            if i == 0 then im1 = game.Nx-1 else im1 = (self.i-1) % game.Nx end
            if i == game.Nx-1 then ip1 = 0 else ip1 = (self.i+1) % game.Nx end
            if j == 0 then jm1 = game.Ny-1 else jm1 = (self.j-1) % game.Ny end
            if j == game.Ny-1 then jp1 = 0 else jp1 = (self.j+1) % game.Ny end

            val = 0
            val = val + game.u[im1+jm1*game.Nx+1]
            val = val + game.u[im1+self.j*game.Nx+1]
            val = val + game.u[im1+jp1*game.Nx+1]
            val = val + game.u[self.i+jm1*game.Nx+1]
            val = val + game.u[self.i+self.j*game.Nx+1]
            val = val + game.u[self.i+jp1*game.Nx+1]
            val = val + game.u[ip1+jm1*game.Nx+1]
            val = val + game.u[ip1+self.j*game.Nx+1]
            val = val + game.u[ip1+jp1*game.Nx+1]
            
            if val > 0 then
                return true
            else 
                return false
            end

        end,

        win = function(self)

            local val = 0
            
            local i
            for i = 1,game.Nx*game.Ny do
                val = val + game.u[i] 
            end
    
            if val == 0 then return true end
    
        end,

    },

    bullet = {

        i = 0,
        j = 0,
        dir = 0,
        col = 6,
        step = 0,
        maxstep = 15,
        use = false,

        draw = function(self)

            if self.use then
                rect(game.x + self.i*(game.w+game.padding), game.y+self.j*(game.h+game.padding), game.w, game.h, self.col)
            end

        end,

        shoot = function(self)

            if not self.use then
                self.i = game.player.i
                self.j = game.player.j
                self.dir = game.player.dir
                self.step = 0
                self.use = true
            end

        end,

        update = function(self)

            if keyp(48, 20, 20) then self:shoot() end

            if self.use and self.step < self.maxstep then
                if self.dir == 0 then 
                    self.j = (self.j-1) % game.Ny
                elseif self.dir == 1 then 
                    self.j = (self.j+1) % game.Ny 
                elseif self.dir == 2 then 
                    self.i = (self.i-1) % game.Nx
                elseif self.dir == 3 then 
                    self.i = (self.i+1) % game.Nx 
                end
                self.step = self.step + 1
            else
                self.i = 0
                self.j = 0
                self.use = false
            end

            self:collide()

        end,

        collide = function(self)

            if game.u[self.i+self.j*game.Nx+1] == 1 then
                game.u[self.i+self.j*game.Nx+1] = 0
                game.hud.score = game.hud.score + 100
                self.use = false
                self.i = 0
                self.j = 0
            end

        end

    },

    particles = {

        t1 = 0,
        t2 = 0,
        speed = 1,
        object = {},

        load = function(self)

            object = {}

            for i = 1,30 do
                local x = math.floor(math.random()*240) 
                local y = math.floor(math.random()*123)
                local v = math.random()
                table.insert(self.object, {x, y, v})
            end

        end,

        draw = function(self)

            for i, p in ipairs(self.object) do
                poke4(self.coord2addr(p[1], p[2]), 15)
            end

        end,

        update = function(self)

            for i, p in ipairs(self.object) do
                p[1] = (p[1] - p[3]*self.speed) % 240 
            end

        end,

        coord2addr = function(x, y)

            return (240 * y + x)

        end,

    },

    death_seq = {

        show = false,

        load = function(self)

            self.show = true
            life.load_mat(game, game.player.i, game.player.j, life.mat[4])

        end,

        draw = function(self)

            print("GAME OVER", 68, 50, 6, false, 2)
            print("press 'space' to return", 57, 63, 6)
        
        end,

        update = function(self)

            if keyp(48) then
                game.mode = false
                self.show = false
                music(0)
            end

        end

    },

    win_seq = {

        t = 0,
        show = false,

        load = function(self)

            game.pause = true
            self.t = time()
            self.show = true
            life.load_mat(game, 23, 12, self.mat)

        end,

        update = function(self)
            
            if time() - self.t > 2000 then
                game:unpause()
                if keyp(48) then
                    game.mode = false
                    self.show = false
                    music(0)
                end
            end

        end,

        draw = function(self)
            
            if time() - self.t > 3000 then
                print("press 'space' to return", 57, 55, 6)
            end

        end,

        mat = {{1,0,0,1,0,0,1,1,0,0,1,0,0,1,0,0,0,1,0,1,0,1,0,1,0,1,0,0,1},
               {1,0,0,1,0,1,0,0,1,0,1,0,0,1,0,0,0,1,0,1,0,1,0,1,0,1,1,0,1},
               {1,1,1,1,0,1,0,0,1,0,1,0,0,1,0,0,0,1,0,1,0,1,0,1,0,1,0,1,1},
               {0,0,0,1,0,1,0,0,1,0,1,0,0,1,0,0,0,0,1,0,1,0,0,1,0,1,0,0,1},
               {1,1,1,0,0,0,1,1,0,0,0,1,1,0,0,0,0,0,1,0,1,0,0,1,0,1,0,0,1}}

    },

    hud = {

        start_time = 0,
        t = 0,
        score = 0,

        load = function(self)
            
            self.score = 0
            self.start_time = time()
        
        end,

        update = function(self)

            self.t = math.floor((time()-self.start_time)/1000)

        end,

        draw = function(self)

            print(string.format("score: %08d", self.score), 3, 126, 15, true)
            print(string.format("time: %02d:%02d", self.t//60, self.t%60), 122, 126, 15, true)
            print(string.format("%dFPS", FPS), 207, 126, 15, true)

        end

    }
}


function elapse()

    if t1 == nil then t1 = 0 end
    t2 = time()
    dt = t2 - t1
    t1 = t2
    FPS = round(1000/dt)

end


function round(a, n)

    local mult = 10^(n or 0)
    return math.floor(a * mult + 0.5) / mult

end


function between(x, a, b)

    return x >= a and x < b

end


ui = {

    draw = function(self)

        self.dialog:draw()
        self.menu:draw()

        if life.pause then
            print(string.format("%.0fFPS PAUSED", FPS), 3, 3, 15, true)
        else
            print(string.format("%.0fFPS", FPS), 3, 3, 15, true)
        end

    end,

    update = function(self)

        ui.dialog:update()
        ui.menu:update()

    end,

    menu = {

        x = 3,
        y = 33,
        current = 0,
        mode = "classic",
        select = false,

        draw = function(self)
            
            print(string.format("speed: %.3fx", life.speed), self.x, 13)
            print("SETTINGS", self.x, self.y)
            rect(1, self.y+8+10*self.current, 103, 9, 10)
            print("speed x2", self.x, self.y+10)
            print("speed x0.5", self.x, self.y+20)
            print("clear board", self.x, self.y+30)
            print("load initial state", self.x, self.y+40)
            print("space battle mode", self.x, self.y+50)

        end,

        update = function(self)

            if btnp(0) then 
                self.current = (self.current - 1) % 5
            elseif btnp(1) then
                self.current = (self.current + 1) % 5
            end

            if btnp(4) then
                if self.current == 0 and life.speed < 32 then
                    life.speed = life.speed * 2
                elseif self.current == 1 and life.speed > 0.125 then
                    life.speed = life.speed * 0.5
                elseif self.current == 2 then
                    life:clear()
                elseif self.current == 3 then
                    ui.selection.show = true
                elseif self.current == 4 then
                    ui.selection.show = true
                end
            end

        end,

    },

    dialog = {

        counter = 0,

        draw = function(self)
            
            rect(1, 98, 103, 37, 10)
            spr(1+(t%60)//30*2, 3, 101, 14, 2, 0, 0, 2, 2) 
            print(self.say(self.log[self.counter + 1]), 38, 102)

        end,

        say = function(text)

            local s = ""
            local w = 0

            -- split with delimiter " "
            for word in text:gmatch("[^ ]+") do
                w = w + print(word .. " ", 0, -6)
                if w < 70 then
                    s = s .. word .. " "
                else
                    s = s .. "\n" .. word .. " "
                    w = print(word .. " ", 0, -6)
                end
            end

            return s

        end,

        update = function(self)

            self.counter = math.floor(t/400) % #self.log

        end,

        log = {
            "Make patterns on the board and watch it evlove!",
            "Left click to turn on, right click to turn off.",
            "Try out game mode for some space action!",
            "Do you know you can hold down 'spacebar' to shoot?",
            "Why not load up some interesting patterns.",
            "You can pause by pressing 'spacebar'.",
        }

    },

    selection = {

        current = 0,
        show = false,

        draw = function(self)

            print("Selection", 70, 10, 15, false, 2)
            life.show_mat(life.mat[self.current+1], 60, 60)
            print(self.log[self.current+1], 120, 40, 15)
            if ui.menu.current == 3 then
                print("left/right arrow keys to navigate \n'z' to select", 30, 110)
            elseif ui.menu.current == 4 then
                print("arrow keys to navigate \n'z' to select\n'spacebar' to shoot", 30, 110)
            end
            

        end,

        update = function(self)

            if btnp(2) then 
                self.current = (self.current - 1) % 7
            elseif btnp(3) then
                self.current = (self.current + 1) % 7
            end

            if btnp(4) then
                if ui.menu.current == 3 then
                    life.pause = true
                    life:load_mat(13, 13, life.mat[self.current+1])
                    self.show = false
                elseif ui.menu.current == 4 then
                    game:load()
                    game.player:load()
                    game.hud:load()
                    self.show = false
                end
            end

        end,

        log = {

[[
R-pentomino

First discovered 
pattern that takes
very long time to
stablize.
]],

[[
Diehard

Disappears 
completely after 
130 generations.

Believed to be the 
longest for patterns 
with 7 or fewer 
live cell.
]],

[[
Acorn

Evolve for 5206 
generations !
]],

[[
Pulsar

Loop after 3 
generations.
]],

[[
Penta-dectlon

Loop after 15 
generations.
]],

[[
Glider

Move at an 45 
degree angle.
]],

[[
Spaceship

To infinity 
and beyond!
]]
        }

    }
}

intro = {

    show = true,
    counter = 1,

    draw = function(self)
        
        spr(1+(t%60)//30*2, 25, 52, 14, 2, 0, 0, 2, 2) 
        print(self.log[self.counter], 65, 18)
        print("press 'z' to continue", 100, 110)

    end,

    update = function(self)

        if btnp(4) then
            self.counter = self.counter + 1
        end

        if self.counter > #(self.log) then
            self.show = false
        end

    end,

    log = {
[[
Welcome to Conway's 
Game of Life.

John H. Conway was a 
renowned mathematician
and inspiration to many. 

Inventing the Game of Life, 
he answered a few quesitons 
on the subject of self-
replicating machines, 
Turing completeness, and 
the nature of undecidability. 
]],

[[
In April 2020, he passed 
away amid the COVID-19 
pandemic.

If you are intersted, do 
listen to the man himself 
talk about the Game of Life 
(and other bits of Maths)
on the Numberphile YouTube
channel!
]],

[[
Game of Life by

    John H. Conway

Concept and Programming
    
    @pke1029

Music 

    Tiziana Comito
]],

[[
arrow keys:   navigate menu

z:                select

spacebar:      pause

left click:     turn on cell

right click:    turn off cell

F8:               screenshot

F9:               record gif
]]
    }

}


t = 0
W = 240
H = 136

music(0)
life:load()

function TIC()

    elapse()
    cls(1)

    if intro.show then
        
        intro:update()
        intro:draw()

    elseif ui.selection.show then

        ui.selection:update()
        ui.selection:draw()

    elseif game.mode then

        game:update()
        game:draw()

    else

        ui:update()
        life:update()
        
        ui:draw()
        life:draw()
        
    end

    t = t+1

end

