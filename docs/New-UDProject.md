---
external help file: UDTemplate-help.xml
Module Name: UDTemplate
online version: https://github.com/ArtisanByteCrafter/ud-template/blob/master/docs/New-UDProject.md
schema: 2.0.0
---

# New-UDProject

## SYNOPSIS
Creates the folder structure for a new UD project and sets some defaults for a new dashboard.

## SYNTAX

```
New-UDProject [-ProjectName] <String> [-Destination] <String> [[-Port] <String>] [-SetAsCurrentLocation]
 [<CommonParameters>]
```

## DESCRIPTION
Creates folder structure, sets a default port, and sets dashboard to import all .ps1 files in /src

## EXAMPLES

### EXAMPLE 1
```
New-UDProject -ProjectName myProject -Port 8080 -Destination C:\Temp
```

Creates a new project called myProject, configures the listening port as 8080, at C:\Temp.

## PARAMETERS

### -ProjectName
The name of the project.
The dashboard will use this value for it's title, but this is configurable in dbconfig.json

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Destination
The folder where the dashboard project will be located

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Port
The port on which to listen.
The default is port 80.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 80
Accept pipeline input: False
Accept wildcard characters: False
```

### -SetAsCurrentLocation
If included, this parameter will change the current working directory to the new project root after creation.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Inputs (if any)
## OUTPUTS

### PSCustomObject of the dashboard module name and location
## NOTES
General notes

## RELATED LINKS
