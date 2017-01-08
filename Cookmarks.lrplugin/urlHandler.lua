return {
    URLHandler = function(url)
        if url:sub( 1, 1 ) == '"' then -- double-quote wrapped format.
            cookmarks:urlHandler( url:sub( 2, -2 ) ) -- strip double-quotes.
        else
            cookmarks:urlHandler( url )
        end
    end
}