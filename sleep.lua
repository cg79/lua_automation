local clock = os.clock
function sleep(n)-- seconds
    local t0 = clock()
    while clock() - t0 <= n do end
end

--printing the elements in the list one after the other by pausing the program for 20 seconds after printing each element
mylist = {"Learning", "is", "fun"}

for a = 1,3 do
    print("\n")
    print(mylist[a])
    print("\nPlease wait for 10 seconds\n")
    sleep(10)
end