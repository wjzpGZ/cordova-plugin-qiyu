/**
 * Created by v2 on 2017/9/15.
 */
module.exports = function(ctx) {
    var fs = ctx.requireCordovaModule('fs'),
        path = ctx.requireCordovaModule('path');
		
    //正则表达式替换文本
    function replace_string_in_file(filename, to_replace, replace_with) {
        var data = fs.readFileSync(filename, 'utf8');
        if(data.indexOf('xmlns:tools="http://schemas.android.com/tools"') > 0){
            console.info("已经添加过 tools 命名空间");
            return;
        }
        var result = data.replace(to_replace, replace_with);
        fs.writeFileSync(filename, result, 'utf8');
    }
    var manifestPath = path.join(ctx.opts.projectRoot, 'platforms/android/AndroidManifest.xml');
    console.log( " replace AndroidManifest ");
    if (fs.existsSync(manifestPath)) {
        replace_string_in_file(manifestPath, "<manifest", '<manifest xmlns:tools="http://schemas.android.com/tools"');
        //replace_string_in_file(manifestPath, "<manifest", '<manifest xmlns:tools="http://schemas.android.com/tools"');

    } else {
        console.log("missing: " + manifestPath);
    }


};