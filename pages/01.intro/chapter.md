---
title: Introduction
taxonomy:
    category:
        - docs
child_type: docs
highlight:
    theme: monokai
    enabled: true
    lines: true
---

### Chapter 0

# Introduction

A VHDL and Verilog Processor designed for academic purposes and future potential as a soft-core processor build for space

```html
<h1>h1 Heading</h1>
<h2>h2 Heading</h2>
<h3>h3 Heading</h3>
<h4>h4 Heading</h4>
<h5>h5 Heading</h5>
<h6>h6 Heading</h6>
```

```vhdl
---------------------------------------
-- driver (ESD book figure 2.3)		
--
-- two descriptions provided
----------------------------------------

library ieee;
use ieee.std_logic_1164.all;

----------------------------------------

entity Driver is
port(	x: in std_logic;
	F: out std_logic
);
end Driver;  

----------------------------------------

architecture behv1 of Driver is
begin

    process(x)
    begin
        -- compare to truth table
        if (x='1') then
            F <= '1';
        else
            F <= '0';
        end if;
    end process;

end behv1;

architecture behv2 of Driver is 
begin 

    F <= x; 

end behv2; 

------------------------------------------
```