// Algoritmo Principal: Sistema de Gestión Universitaria

Algoritmo Universidad
	// "Base de datos"
	Dimension materias[10], alumnos[10], profesores[10], materiaProfesor[10]
	Dimension inscripciones[10,10], notas[10,10]
	Dimension usuarios[30], contraseñas[30], roles[30] // roles: 1=Admin,2=Profesor,3=Alumno
	Dimension intentosFallidos[30], estadoUsuario[30]
	
	// Contadores generales del sistema
	Definir totalMaterias, totalAlumnos, totalProfesores, totalUsuarios Como Entero
	
	// Cargamos los datos iniciales (admin, materias base)
	InicializarDatos(materias, totalMaterias, usuarios, contraseñas, roles, totalUsuarios, intentosFallidos, estadoUsuario)
	
	// El programa corre en un bucle hasta que el usuario elige salir
	Definir rolActual, idUsuarioActual Como Entero
	Definir salirPrograma Como Logico
	salirPrograma <- Falso
	
	Repetir
		// Primero, el login para saber quién es y qué puede hacer
		Login(usuarios, contraseñas, roles, totalUsuarios, intentosFallidos, estadoUsuario, idUsuarioActual, rolActual, salirPrograma)
		
		Si NO salirPrograma Entonces
			Segun rolActual Hacer
				1:
					MenuAdministrador(materias, alumnos, profesores, materiaProfesor, inscripciones, notas, usuarios, contraseñas, roles, totalMaterias, totalAlumnos, totalProfesores, totalUsuarios, intentosFallidos, estadoUsuario)
				2:
					MenuProfesor(materias, alumnos, profesores, materiaProfesor, notas, inscripciones, totalMaterias, totalAlumnos, totalProfesores, idUsuarioActual, usuarios, contraseñas, totalUsuarios)
				3:
					MenuAlumno(materias, alumnos, notas, inscripciones, totalMaterias, totalAlumnos, idUsuarioActual, usuarios, contraseñas, totalUsuarios)
			FinSegun
		FinSi
	Hasta Que salirPrograma
	
	Escribir "Programa finalizado."
FinAlgoritmo

// MÓDULOS DEL SISTEMA

// Subproceso que prepara los datos para que el sistema arranque
SubProceso InicializarDatos(materias Por Referencia, totalMaterias Por Referencia, usuarios Por Referencia, contraseñas Por Referencia, roles Por Referencia, totalUsuarios Por Referencia, intentosFallidos Por Referencia, estadoUsuario Por Referencia)
	totalUsuarios <- 1
	totalMaterias <- 3
	
	materias[1] <- "Programacion"
	materias[2] <- "Matematica"
	materias[3] <- "Algoritmos"
	
	usuarios[1] <- "admin"
	contraseñas[1] <- "1234"
	roles[1] <- 1
	
	// Dejamos a todos los usuarios como activos y sin intentos fallidos
	Para i <- 1 Hasta 30 Hacer
		intentosFallidos[i] <- 0
		estadoUsuario[i] <- 1 // 1 = Activo, 0 = Bloqueado
	FinPara
FinSubProceso

// Módulo de Login: valida al usuario y controla los intentos fallidos
SubProceso Login(usuarios, contraseñas, roles, totalUsuarios, intentosFallidos Por Referencia, estadoUsuario Por Referencia, idUsuarioActual Por Referencia, rolActual Por Referencia, salir Por Referencia)
	Definir user, pass Como Cadena
	Definir encontrado Como Logico
	Definir i, id_temporal Como Entero
	
	Repetir
		Escribir "--- INICIO DE SESIÓN ---"
		Escribir "Usuario (0 para salir):"
		Leer user
		
		si user = "0" Entonces
			salir <- Verdadero
		SiNo
			// Busco el id del usuario para poder trabajar con sus datos
			id_temporal <- BuscarIdUsuario(usuarios, totalUsuarios, user)
			
			// Chequeo si el usuario existe y si no está bloqueado
			Si id_temporal = 0 Entonces
				Escribir "Usuario no existe."
				Esperar Tecla
			SiNo
				Si estadoUsuario[id_temporal] = 0 Entonces
					Escribir "ACCESO DENEGADO: El usuario está bloqueado."
					Esperar Tecla
				SiNo
					// Si todo está OK, pido la clave
					Escribir "Contraseña:"
					Leer pass
					
					Si contraseñas[id_temporal] = pass Entonces
						Escribir "¡Bienvenido!"
						encontrado <- Verdadero
						rolActual <- roles[id_temporal]
						idUsuarioActual <- id_temporal
						intentosFallidos[id_temporal] <- 0 // Si entró bien, se reinician los intentos fallidos
					SiNo
						intentosFallidos[id_temporal] <- intentosFallidos[id_temporal] + 1
						Escribir "Contraseña incorrecta. Intento ", intentosFallidos[id_temporal], " de 3."
						Si intentosFallidos[id_temporal] >= 3 Entonces
							estadoUsuario[id_temporal] <- 0 // Si llega a 3 intentos, se bloquea
							Escribir "Ha superado el límite de intentos. El usuario ha sido bloqueado."
						FinSi
						Esperar Tecla
					FinSi
				FinSi
			FinSi
			Limpiar Pantalla
		FinSi
	Hasta Que encontrado O salir
FinSubProceso

//Administrador
SubProceso MenuAdministrador(materias Por Referencia, alumnos Por Referencia, profesores Por Referencia, materiaProfesor Por Referencia, inscripciones, notas, usuarios Por Referencia, contraseñas Por Referencia, roles Por Referencia, totalMaterias Por Referencia, totalAlumnos Por Referencia, totalProfesores Por Referencia, totalUsuarios Por Referencia, intentosFallidos Por Referencia, estadoUsuario Por Referencia)
	//Variables
	Definir op, opcionModificar, idModificar, id_existente Como Entero
	Definir nuevoNombre, nuevaMateria, nuevoAlumno, nuevoProfesor, pass Como Cadena
	Repetir
		Escribir "=== Menu Administrador ==="
		Escribir "1. Crear materia"
		Escribir "2. Crear alumno"
		Escribir "3. Crear profesor"
		Escribir "4. Asignar profesor a materia"
		Escribir "5. Modificar Datos"
		Escribir "6. Ver estadisticas"
		Escribir "7. Gestionar Usuarios"
		Escribir "8. Salir"
		Leer op
		Limpiar Pantalla
		
		Segun op Hacer
			1://Crear Materia
				Si totalMaterias < 10 Entonces
					Escribir "Ingrese el nombre de la nueva materia:"
					Leer nuevaMateria
					totalMaterias <- totalMaterias + 1
					materias[totalMaterias] <- nuevaMateria
					Escribir ""
					Escribir "¡Materia ", nuevaMateria, " creada con éxito!"
					Escribir ""
					Escribir "Presione una tecla para continuar..."
					Esperar Tecla
					Limpiar Pantalla
				SiNo
					Escribir "No se pueden agregar mas materias."
					Escribir ""
					Escribir "Presione una tecla para continuar..."
					Esperar Tecla
					Limpiar Pantalla
				FinSi
			2://Crear Alumno
				Si totalAlumnos < 10 Entonces
					Escribir "Ingrese el nombre del nuevo alumno:"
					Leer nuevoAlumno
					
					id_existente <- BuscarIdUsuario(usuarios, totalUsuarios, nuevoAlumno)
					
					Si id_existente <> 0 Entonces
						Escribir "Error: El nombre de usuario ", nuevoAlumno, " ya existe."
						Escribir ""
						Escribir "Presione una tecla para continuar..."
						Esperar Tecla
						Limpiar Pantalla
					SiNo
						// El nombre no existe, así que lo creamos
						totalAlumnos <- totalAlumnos + 1
						alumnos[totalAlumnos] <- nuevoAlumno
						totalUsuarios <- totalUsuarios + 1
						usuarios[totalUsuarios] <- nuevoAlumno
						Escribir "Defina contraseña para ", nuevoAlumno, ":"
						Leer pass
						contraseñas[totalUsuarios] <- pass
						roles[totalUsuarios] <- 3
						Escribir "Alumno creado con éxito."
					FinSi
				SiNo
					Escribir "No se pueden agregar más alumnos."
				FinSi
			3://Crear Profesor
				Si totalProfesores < 10 Entonces
					Escribir "Ingrese el nombre del nuevo profesor:"
					Leer nuevoProfesor
					
					id_existente <- BuscarIdUsuario(usuarios, totalUsuarios, nuevoProfesor)
					
					Si id_existente <> 0 Entonces
						Escribir "Error: El nombre de usuario ", nuevoProfesor, " ya existe."
						Escribir ""
						Escribir "Presione una tecla para continuar..."
						Esperar Tecla
						Limpiar Pantalla
					SiNo
						// El nombre no existe, así que lo creamos
						totalProfesores <- totalProfesores + 1
						profesores[totalProfesores] <- nuevoProfesor
						totalUsuarios <- totalUsuarios + 1
						usuarios[totalUsuarios] <- nuevoProfesor
						Escribir "Defina contraseña para ", nuevoProfesor, ":"
						Leer pass
						contraseñas[totalUsuarios] <- pass
						roles[totalUsuarios] <- 2
						Escribir "Profesor creado con éxito."
					FinSi
				SiNo
					Escribir "No se pueden agregar más profesores."
				FinSi
			4://Asignar Materia
				Si totalMaterias > 0 Y totalProfesores > 0 Entonces
					Escribir "Seleccione la materia:"
					Para i<-1 Hasta totalMaterias Hacer
						Escribir i, ". ", materias[i]
					FinPara
					Leer idMateria
					Escribir "Seleccione el profesor:"
					Para i<-1 Hasta totalProfesores Hacer
						Escribir i, ". ", profesores[i]
					FinPara
					Leer idProfesor
					materiaProfesor[idMateria] <- idProfesor
					Escribir "Profesor asignado."
					Escribir ""
					Escribir "Presione una tecla para continuar..."
					Esperar Tecla
					Limpiar Pantalla
				SiNo
					Escribir "Debe crear materias y profesores primero."
					Escribir ""
					Escribir "Presione una tecla para continuar..."
					Esperar Tecla
					Limpiar Pantalla
				FinSi
			5://Modificar Datos
				Repetir
					Escribir "--- Submenú Modificar ---"
					Escribir "1. Cambiar nombre de Alumno"
					Escribir "2. Cambiar nombre de Materia"
					Escribir "3. Volver"
					Leer opcionModificar
					Segun opcionModificar
						1:
							Escribir "Seleccione el alumno a modificar:"
							Para i<-1 Hasta totalAlumnos Hacer
								Escribir i, ". ", alumnos[i]
							FinPara
							Leer idModificar
							Si idModificar>=1 y idModificar<=totalAlumnos Entonces
								Escribir "Ingrese el nuevo nombre para ", alumnos[idModificar], ":"
								Leer nuevoNombre
								alumnos[idModificar] <- nuevoNombre
								Escribir "Nombre actualizado."
							SiNo
								Escribir "Opción no válida."
							FinSi
						2:
							Escribir "Seleccione la materia a modificar:"
							Para i<-1 Hasta totalMaterias Hacer
								Escribir i, ". ", materias[i]
							FinPara
							Leer idModificar
							Si idModificar>=1 y idModificar<=totalMaterias Entonces
								Escribir "Ingrese el nuevo nombre para ", materias[idModificar], ":"
								Leer nuevoNombre
								materias[idModificar] <- nuevoNombre
								Escribir "Nombre actualizado."
							SiNo
								Escribir "Opción no válida."
							FinSi
					FinSegun
					Si opcionModificar <> 3 Entonces
						Esperar Tecla
						Limpiar Pantalla
					FinSi
				Hasta Que opcionModificar = 3
			6://Estadisticas
				Escribir "=== Estadisticas ==="
				Para j<-1 Hasta totalMaterias Hacer
					cont <- 0
					Para i<-1 Hasta totalAlumnos Hacer
						Si inscripciones[i,j] = 1 Entonces
							cont <- cont + 1
						FinSi
					FinPara
					Escribir materias[j], ": ", cont, " alumnos."
				FinPara
				Escribir ""
				Escribir "Presione una tecla para continuar..."
				Esperar Tecla
				Limpiar Pantalla
			7://Desbloq usuarios
				Escribir "--- Gestión de Usuarios ---"
				Para i <- 1 Hasta totalUsuarios Hacer
					Escribir Sin Saltar, i, ". ", usuarios[i]
					Si estadoUsuario[i] = 1 Entonces
						Escribir " (Estado: Activo)"
					SiNo
						Escribir " (Estado: Bloqueado)"
					FinSi
				FinPara
				Escribir "Seleccione un usuario para cambiar su estado (0 para cancelar):"
				Leer idModificar
				Si idModificar > 0 Y idModificar <= totalUsuarios Entonces
					Si estadoUsuario[idModificar] = 1 Entonces
						estadoUsuario[idModificar] <- 0
						Escribir "Usuario ", usuarios[idModificar], " ha sido BLOQUEADO."
					SiNo
						estadoUsuario[idModificar] <- 1
						intentosFallidos[idModificar] <- 0 // Al desbloquear, reiniciamos el contador de intentos
						Escribir "Usuario ", usuarios[idModificar], " ha sido DESBLOQUEADO."
					FinSi
				FinSi
			8:
				Escribir "Cerrando sesión de administrador..."
			De Otro Modo: Escribir "Opción no válida."
		FinSegun
		
	Hasta Que op = 8
FinSubProceso

//Profesor
SubProceso MenuProfesor(materias, alumnos, profesores, materiaProfesor, notas Por Referencia, inscripciones, totalMaterias, totalAlumnos, totalProfesores, idUsuarioLogueado, usuarios, contraseñas Por Referencia, totalUsuarios)
	//Variables
	Definir op, i, cont, opcionMateria, idMateria, nota, cant, idProfesorLocal Como Entero
	Definir suma, promedio Como Real
	Definir pass_actual, pass_nueva1, pass_nueva2 Como Cadena
	Dimension listaMaterias[10]
	
	idProfesorLocal <- BuscarIdUsuario(profesores, totalProfesores, usuarios[idUsuarioLogueado])
	
	Repetir
		Escribir "=== Menu Profesor - ", usuarios[idUsuarioLogueado], " ==="
		Escribir "1. Cargar notas"
		Escribir "2. Ver mis materias (con promedios)"
		Escribir "3. Cambiar Contraseña"
		Escribir "4. Salir"
		Leer op
		Limpiar Pantalla
		
		Si idProfesorLocal > 0 Entonces
			Segun op Hacer
				1: // Cargar Notas
					cont <- 0
					Para i <- 1 Hasta totalMaterias
						Si materiaProfesor[i] = idProfesorLocal Entonces
							cont <- cont + 1
							listaMaterias[cont] <- i
						FinSi
					FinPara
					Si cont = 0 Entonces
						Escribir "No tiene materias asignadas."
					SiNo
						Escribir "Seleccione materia para cargar notas:"
						Para i <- 1 Hasta cont
							Escribir i, ". ", materias[listaMaterias[i]]
						FinPara
						Leer opcionMateria
						idMateria <- listaMaterias[opcionMateria]
						Escribir "Alumnos inscriptos en ", materias[idMateria], ":"
						Para i <- 1 Hasta totalAlumnos
							Si inscripciones[i,idMateria] = 1 Entonces
								Escribir "Ingrese nota para ", alumnos[i], ":"
								Leer nota
								notas[i,idMateria] <- nota
							FinSi
						FinPara
					FinSi
				2: // Ver Materias y Promedios
					cont <- 0
					Para i <- 1 Hasta totalMaterias
						Si materiaProfesor[i] = idProfesorLocal Entonces
							cont <- cont + 1
							listaMaterias[cont] <- i
						FinSi
					FinPara
					Si cont = 0 Entonces
						Escribir "No tiene materias asignadas."
					SiNo
						Escribir "Seleccione materia para ver alumnos:"
						Para i <- 1 Hasta cont
							Escribir i, ". ", materias[listaMaterias[i]]
						FinPara
						Leer opcionMateria
						idMateria <- listaMaterias[opcionMateria]
						
						Escribir "--- Alumnos en ", materias[idMateria], " ---"
						suma <- 0
						cant <- 0
						Para i <- 1 Hasta totalAlumnos
							Si inscripciones[i,idMateria] = 1 Entonces
								Escribir Sin Saltar" - ", alumnos[i], " - Nota: "
								Si notas[i,idMateria] <> 0 Entonces
									Escribir Sin Saltar, notas[i,idMateria]
									Escribir ""
									suma <- suma + notas[i,idMateria]
									cant <- cant + 1
								SiNo
									Escribir Sin Saltar, "(sin nota)"
									Escribir ""
								FinSi
							FinSi
						FinPara
						Si cant > 0 Entonces
							promedio <- suma / cant
							Escribir "---------------------------------"
							Escribir "Promedio de la materia: ", promedio
							Escribir "---------------------------------"
						SiNo
							Escribir "No hay alumnos con notas cargadas en esta materia."
						FinSi
					FinSi
				3: // Cambiar Contraseña
					Escribir "--- Cambio de Contraseña ---"
					Escribir "Ingrese su contraseña actual:"
					Leer pass_actual
					
					Si contraseñas[idUsuarioLogueado] = pass_actual Entonces
						Escribir "Ingrese su nueva contraseña:"
						Leer pass_nueva1
						Escribir "Confirme su nueva contraseña:"
						Leer pass_nueva2
						
						Si pass_nueva1 = pass_nueva2 Entonces
							contraseñas[idUsuarioLogueado] <- pass_nueva1
							Escribir "Contraseña actualizada con éxito."
						SiNo
							Escribir "Las contraseñas nuevas no coinciden."
						FinSi
					SiNo
						Escribir "La contraseña actual es incorrecta."
					FinSi
				4:
					Escribir "Cerrando sesión de profesor..."
			FinSegun
		SiNo
			Escribir "ERROR: No se pudo encontrar el perfil del profesor."
			op <- 4
		FinSi
		
		Si op <> 4 Entonces
			Escribir ""
			Escribir "Presione una tecla para continuar..."
			Esperar Tecla
			Limpiar Pantalla
		FinSi
		
	Hasta Que op = 4
FinSubProceso
//Alumno
SubProceso MenuAlumno(materias, alumnos, notas, inscripciones Por Referencia, totalMaterias, totalAlumnos, idUsuarioLogueado, usuarios, contraseñas Por Referencia, totalUsuarios)
	//Variables
	Definir op, i, j, idMateria, cant Como Entero
	Definir suma, promedio Como Real
	Definir pass_actual, pass_nueva1, pass_nueva2 Como Cadena
	
	Definir idAlumnoLocal Como Entero
	idAlumnoLocal <- BuscarIdUsuario(alumnos, totalAlumnos, usuarios[idUsuarioLogueado])
	
	Repetir
		Escribir "=== Menu Estudiante - ", usuarios[idUsuarioLogueado]," ==="
		Escribir "1. Inscribirse en materia"
		Escribir "2. Ver mis notas y promedio"
		Escribir "3. Cambiar Contraseña"
		Escribir "4. Salir"
		Leer op
		Limpiar Pantalla
		
		Si idAlumnoLocal > 0 Entonces
			Segun op Hacer
				1: // Inscribirse en materia
					Escribir "Materias disponibles:"
					Para i<-1 Hasta totalMaterias Hacer
						Escribir i, ". ", materias[i]
					FinPara
					Escribir "Seleccione materia para inscribirse:"
					Leer idMateria
					inscripciones[idAlumnoLocal, idMateria] <- 1
					Escribir "Inscripción exitosa."
				2: // Ver mis notas y promedio
					Escribir "--- Tus Notas ---"
					suma <- 0
					cant <- 0
					Para j<-1 Hasta totalMaterias Hacer
						Si inscripciones[idAlumnoLocal,j] = 1 Entonces
							Escribir materias[j], ": "
							Si notas[idAlumnoLocal,j] <> 0 Entonces
								Escribir "   Nota: ", notas[idAlumnoLocal,j]
								suma <- suma + notas[idAlumnoLocal,j]
								cant <- cant + 1
							SiNo
								Escribir "   (sin nota cargada)"
							FinSi
						FinSi
					FinPara
					Si cant > 0 Entonces
						promedio <- suma / cant
						Escribir "---------------------------------"
						Escribir "Tu promedio general: ", promedio
						Escribir "---------------------------------"
					SiNo
						Escribir "Aún no tienes notas cargadas."
					FinSi
				3: // Cambiar Contraseña
					Escribir "--- Cambio de Contraseña ---"
					Escribir "Ingrese su contraseña actual:"
					Leer pass_actual
					
					Si contraseñas[idUsuarioLogueado] = pass_actual Entonces
						Escribir "Ingrese su nueva contraseña:"
						Leer pass_nueva1
						Escribir "Confirme su nueva contraseña:"
						Leer pass_nueva2
						
						Si pass_nueva1 = pass_nueva2 Entonces
							contraseñas[idUsuarioLogueado] <- pass_nueva1
							Escribir "Contraseña actualizada con éxito."
						SiNo
							Escribir "Las contraseñas nuevas no coinciden."
						FinSi
					SiNo
						Escribir "La contraseña actual es incorrecta."
					FinSi
				4:
					Escribir "Cerrando sesión de alumno..."
			FinSegun
		SiNo
			Escribir "ERROR: No se pudo encontrar el perfil del alumno."
			op <- 4
		FinSi
		
		Si op <> 4 Entonces
			Escribir ""
			Escribir "Presione una tecla para continuar..."
			Esperar Tecla
			Limpiar Pantalla
		FinSi
		
	Hasta Que op = 4
FinSubProceso

// Función de ayuda para buscar la posición de un usuario en un arreglo
Funcion id <- BuscarIdUsuario(lista_nombres, total_elementos, nombre_buscar)
	Definir i, id Como Entero
	id <- 0 // Devuelve 0 si el nombre no está en la lista
	i <- 1
	Mientras i <= total_elementos Y id = 0 Hacer
		Si lista_nombres[i] = nombre_buscar Entonces
			id <- i
		FinSi
		i <- i + 1
	FinMientras
FinFuncion