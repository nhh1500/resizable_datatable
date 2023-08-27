# resizable_datatable
<img src="https://media.discordapp.net/attachments/343876281793773578/1145327302507499561/resizable_dt.gif.gif?width=1014&height=868" width = 1000 height = 850/>

## Features

A resizable datatable that able to resize column width

## Installing
Add this yo your package's `pubspec.yaml` file:
```yaml
dependencies:
  resizable_datatable:
    git:
      url: https://github.com/nhh1500/resizable_datatable
```

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage
```dart
ResizableDataTable(
          autoFit: true,
          headerHeight: 30,
          header: List.generate(
              3,
              (index) =>
                  ResizableHeader('Column $index', minWidth: 30, width: 100)),
          data: List.generate(
              10,
              (index) => List.generate(3, (col) {
                    final text =
                        'ID $index Col $col ${'1' * Random().nextInt(50)}';
                    return text;
                  })),
        )
```

## Additional information
ResizableDataTable
| Parameters | Description  
| -----------| -----------------
| autoFit | set the column width to automatically fit the contents 
| headerHeight | the height of the datatable header 
| header | the list of resizableHeader which define the column name, with, minWidth, etc... 
| data | the list of the data 
| backgroundColor | background color of the datatable widget 
