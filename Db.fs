module SuaveMusicStore.Db

open System
open FSharp.Data.Sql
open FSharp.Data.Sql.Common

 
let [<Literal>] dbVendor = Common.DatabaseProviderTypes.POSTGRESQL

let [<Literal>] connString = "Server=localhost;Database=SuaveMusicStore;User Id=postgres"
let [<Literal>] connexStringName = "DefaultConnectionString"

//let [<Literal>] resPath = @"/Users/Tonyx/Projects/SuaveMusicStore/SuaveMusicStore/packages/Npgsql.3.1.8/lib/net451"
let [<Literal>] resPath = @"/Users/Tonyx/bin/npgsqldir"
 
let [<Literal>] indivAmount = 1000

let [<Literal>] useOptTypes  = false

let [<Literal>]  newConnString= "postgres@localhost/postgres"


type Sql =
    SqlDataProvider< 
        dbVendor,
        connString,
        "",         //ConnectionNameString can be left empty 
        resPath,
        indivAmount,
        useOptTypes>





type DbContext = Sql.dataContext
type Album = DbContext.``public.albumsEntity``
type Artist = DbContext.``public.artistsEntity`` 
type Genre = DbContext.``public.genresEntity``
type AlbumDetails = DbContext.``public.albumdetailsEntity``
type User = DbContext.``public.usersEntity``  
type Cart = DbContext.``public.cartsEntity`` 
type CartDetails = DbContext.``public.cartdetailsEntity`` 
type BestSeller = DbContext.``public.bestsellersEntity``  

let getContext() = Sql.GetDataContext()

let firstOrNone s = s |> Seq.tryFind (fun _ -> true)

let getGenres (ctx : DbContext) : Genre list = 
    ctx.Public.Genres |> Seq.toList

let getArtists (ctx : DbContext) : Artist list = 
    ctx.Public.Artists    |> Seq.toList

let getAlbumsForGenre genreName (ctx : DbContext) : Album list = 
    query { 
        for album in ctx.Public.Albums do
            join genre in ctx.Public.Genres on (album.Genreid = genre.Genreid)
            where (genre.Name = genreName)
            select album
    }
    |> Seq.toList

let getAlbumDetails id (ctx : DbContext) : AlbumDetails option = 
    query { 
        for album in ctx.Public.Albumdetails  do
            where (album.Albumid = id)
            select album
    } |> firstOrNone

let getAlbumsDetails (ctx : DbContext) : AlbumDetails list = 
    ctx.Public.Albumdetails |> Seq.toList

let getBestSellers (ctx : DbContext) : BestSeller list  =
    ctx.Public.Bestsellers |> Seq.toList

let getAlbum id (ctx : DbContext) : Album option = 
    query { 
        for album in ctx.Public.Albums do
            where (album.Albumid = id)
            select album
    } |> firstOrNone

let validateUser (username, password) (ctx : DbContext) : User option =
    query {
        for user in ctx.Public.Users do
            where (user.Username = username && user.Password = password)
            select user
    } |> firstOrNone

let getUser username (ctx : DbContext) : User option = 
    query {
        for user in ctx.Public.Users do
        where (user.Username = username)
        select user
    } |> firstOrNone

let getCart cartId albumId (ctx : DbContext) : Cart option =
    query {
        for cart in ctx.Public.Carts  do
            where (cart.Cartid = cartId && cart.Albumid = albumId)
            select cart
    } |> firstOrNone

let getCarts cartId (ctx : DbContext) : Cart list =
    query {
        for cart in ctx.Public.Carts do
            where (cart.Cartid = cartId)
            select cart
    } |> Seq.toList

let getCartsDetails cartId (ctx : DbContext) : CartDetails list =
    query {
        for cart in ctx.Public.Cartdetails do
            where (cart.Cartid = cartId)
            select cart
    } |> Seq.toList

let createAlbum (artistId, genreId, price, title) (ctx : DbContext) =
    ctx.Public.Albums.Create(artistId, genreId, price, title) |> ignore
    ctx.SubmitUpdates()

let updateAlbum (album : Album) (artistId, genreId, price, title) (ctx : DbContext) =
    album.Artistid <- artistId
    album.Genreid <- genreId
    album.Price <- price
    album.Title <- title
    ctx.SubmitUpdates()

let deleteAlbum (album : Album) (ctx : DbContext) = 
    album.Delete()
    ctx.SubmitUpdates()

let addToCart cartId albumId (ctx : DbContext)  =
    match getCart cartId albumId ctx with
    | Some cart ->
        cart.Count <- cart.Count + 1
    | None ->
        ctx.Public.Carts.Create(albumId, cartId, 1, DateTime.UtcNow) |> ignore
    ctx.SubmitUpdates()

let removeFromCart (cart : Cart) albumId (ctx : DbContext) = 
    cart.Count <- cart.Count - 1
    if cart.Count = 0 then cart.Delete()
    ctx.SubmitUpdates()

let upgradeCarts (cartId : string, username :string) (ctx : DbContext) =
    for cart in getCarts cartId ctx do
        match getCart username cart.Albumid ctx with
        | Some existing ->
            existing.Count <- existing.Count +  cart.Count
            cart.Delete()
        | None ->
            cart.Cartid <- username
    ctx.SubmitUpdates()

let newUser (username, password, email) (ctx : DbContext) =
    let user = ctx.Public.Users.Create(email, password, "user", username)
    ctx.SubmitUpdates()
    user

let placeOrder (username : string) (ctx : DbContext) =
    let carts = getCartsDetails  username ctx
    //let total = carts |> List.sumBy (fun c -> (decimal) c.Count * c.Price)
    let total = carts |> List.sumBy (fun c ->  (decimal) c.Count * c.Price)
    let order = ctx.Public.Orders.Create(DateTime.UtcNow, total)
    order.Username <- username
    ctx.SubmitUpdates()
    for cart in carts do
        let orderDetails = ctx.Public.Orderdetails.Create(cart.Albumid, order.Orderid, cart.Count, cart.Price)
        getCart cart.Cartid cart.Albumid ctx
        |> Option.iter (fun cart -> cart.Delete())
    ctx.SubmitUpdates()