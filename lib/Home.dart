import 'package:flutter/material.dart';
import 'package:wikipedia/wikipedia.dart';
import 'package:wikipediarama/Internet.dart';

class Home extends StatefulWidget
{
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>
{

  Wikipedia wikipedia = Wikipedia();

  final TextEditingController _arama_cont = TextEditingController();

  final ScrollController scr_ctrl = ScrollController();

  dynamic data;

  dynamic pageData;

  bool loading = false;


  String _arama_sonucu = "";

  String _arama_sonucu_title = "";

  Future<void> _ara() async
  {
    setState(() {
      loading = true;
    });
    try
    {
      data = await wikipedia.searchQuery(searchQuery: _arama_cont.text,limit: 1);
      if (data.query != null)
      {
        if (data.query.search.length > 0)
        {
          pageData = await wikipedia.searchSummaryWithPageId(pageId: data.query.search[0].pageid!);
          if(pageData != null)
          {
            setState(()
            {
              _arama_sonucu_title = pageData!.title!;
              _arama_sonucu = pageData!.extract!;
            });
          }
        }
        else
        {
          setState(()
          {
            _arama_sonucu_title = "${_arama_cont.text} bulunamadı.";
            _arama_sonucu = "";
          });
        }
      }
      else
      {
        setState(()
        {
          _arama_sonucu_title = "Lütfen bir şey giriniz.";
          _arama_sonucu = "";
        });
      }
    }
    catch(e)
    {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Bir hata oluştu."),
          backgroundColor: Colors.deepPurple,
        ),
      );
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState()
  {
    super.initState();
    Internet.baslat();
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wikipedia"),
      ),
      body: Scrollbar(
        controller: scr_ctrl,
        child: SingleChildScrollView(
          controller: scr_ctrl,
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        autofocus: true,
                        controller: _arama_cont,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50)
                          ),
                          hintText: "Ara",
                          contentPadding: EdgeInsets.all(20),
                        ),
                        onEditingComplete: _ara,
                      ),
                    ),
                    SizedBox(width: 10),
                    IconButton(
                      iconSize: 30,
                      color: Colors.deepPurple,
                      icon: Icon(Icons.search_rounded),
                      onPressed: _ara,
                    ),
                  ],
                ),
                SizedBox(height: 25),
                loading
                    ? Center(child: CircularProgressIndicator(),)
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_arama_sonucu_title,style: TextStyle(fontSize: 25,color: Colors.deepPurple)),
                    SizedBox(height: 25,),
                    Text(_arama_sonucu,style: TextStyle(fontSize: 20)),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}