// -----------------------------------------------------------------------------
// ALGORITMO PRINCIPAL
// Se encarga de inicializar los datos y controlar el flujo general del programa.
// -----------------------------------------------------------------------------
Algoritmo Universidad_Modularizada
	// --- DEFINICIÓN DE ESTRUCTURAS DE DATOS ---
	Dimension materias[10], alumnos[10], profesores[10], materiaProfesor[10]
	Dimension inscripciones[10,10], notas[10,10]
	Dimension usuarios[30], contraseñas[30], roles[30] // roles: 1=Admin,2=Profesor,3=Alumno
	
	// --- DEFINICIÓN DE VARIABLES GLOBALES ---
	Definir totalMaterias, totalAlumnos, totalProfesores, totalUsuarios Como Entero
	
	// --- INICIALIZACIÓN DE DATOS ---
	InicializarDatos(materias, totalMaterias, usuarios, contraseñas, roles, totalUsuarios)
	
	// --- CICLO PRINCIPAL DEL PROGRAMA ---
	Definir rolActual, idUsuarioActual Como Entero
	Definir salirPrograma Como Logico
	salirPrograma <- Falso
	
	Repetir
		// El subproceso Login se encarga de la autenticación
		Login(usuarios, contraseñas, roles, totalUsuarios, idUsuarioActual, rolActual, salirPrograma)
		
		Si NO salirPrograma Entonces
			Segun rolActual Hacer
				1:
					MenuAdministrador(materias, alumnos, profesores, materiaProfesor, inscripciones, notas, usuarios, contraseñas, roles, totalMaterias, totalAlumnos, totalProfesores, totalUsuarios)
				2:
					MenuProfesor(materias, alumnos, profesores, materiaProfesor, notas, inscripciones, totalMaterias, totalAlumnos, totalProfesores, usuarios[idUsuarioActual])
				3:
					MenuAlumno(materias, alumnos, notas, inscripciones, totalMaterias, totalAlumnos, usuarios[idUsuarioActual])
			FinSegun
		FinSi
	Hasta Que salirPrograma
	
	Escribir "Programa finalizado."
FinAlgoritmo


// =============================================================================
// SUBPROCESOS (MÓDULOS)
// =============================================================================

// -----------------------------------------------------------------------------
// SUBPROCESO: Inicializa los datos base del sistema
// -----------------------------------------------------------------------------
SubProceso InicializarDatos(materias Por Referencia, totalMaterias Por Referencia, usuarios Por Referencia, contraseñas Por Referencia, roles Por Referencia, totalUsuarios Por Referencia)
	totalUsuarios <- 1
	totalMaterias <- 3
	
	materias[1] <- "Programacion"
	materias[2] <- "Matematica"
	materias[3] <- "Algoritmos"
	
	usuarios[1] <- "admin"
	contraseñas[1] <- "1234"
	roles[1] <- 1
FinSubProceso

// -----------------------------------------------------------------------------
// SUBPROCESO: Gestiona el inicio de sesión
// -----------------------------------------------------------------------------
SubProceso Login(usuarios, contraseñas, roles, totalUsuarios, idUsuarioActual Por Referencia, rolActual Por Referencia, salir Por Referencia)
	Definir user, pass Como Cadena
	Definir encontrado Como Logico
	Definir i Como Entero
	
	Repetir
		Escribir "--- INICIO DE SESIÓN ---"
		Escribir "Usuario (0 para salir):"
		Leer user
		
		si user = "0" Entonces
			salir <- Verdadero
		SiNo
			Escribir "Contraseña:"
			Leer pass
			
			encontrado <- Falso
			i <- 1
			Mientras i <= totalUsuarios Y NO encontrado Hacer
				Si usuarios[i] = user Y contraseñas[i] = pass Entonces
					encontrado <- Verdadero
					rolActual <- roles[i]
					idUsuarioActual <- i
				FinSi
				i <- i + 1
			FinMientras
			
			Si NO encontrado Entonces
				Escribir "Usuario o contraseña incorrectos."
				Esperar Tecla
			FinSi
			Limpiar Pantalla
		FinSi
	Hasta Que encontrado O salir
FinSubProceso

// -----------------------------------------------------------------------------
// SUBPROCESO: Menú y acciones del Administrador
// -----------------------------------------------------------------------------
SubProceso MenuAdministrador(materias Por Referencia, alumnos Por Referencia, profesores Por Referencia, materiaProfesor Por Referencia, inscripciones, notas, usuarios Por Referencia, contraseñas Por Referencia, roles Por Referencia, totalMaterias Por Referencia, totalAlumnos Por Referencia, totalProfesores Por Referencia, totalUsuarios Por Referencia)
	Definir op Como Entero
	Repetir
		Escribir "=== Menu Administrador ==="
		Escribir "1. Crear materia"
		Escribir "2. Crear alumno"
		Escribir "3. Crear profesor"
		Escribir "4. Asignar profesor a materia"
		Escribir "5. Modificar Datos"
		Escribir "6. Ver estadisticas"
		Escribir "7. Salir"
		Leer op
		Limpiar Pantalla
		
		Segun op Hacer
			1:
				Si totalMaterias < 10 Entonces
					Escribir "Ingrese el nombre de la nueva materia:"
					Leer nuevaMateria
					totalMaterias <- totalMaterias + 1
					materias[totalMaterias] <- nuevaMateria
					Escribir "" // Una línea en blanco para separar
					Escribir "¡Materia ", nuevaMateria, " creada con éxito!" // <--- MENSAJE AGREGADO
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
			2:
				Si totalAlumnos < 10 Entonces
					Escribir "Ingrese el nombre del nuevo alumno:"
					Leer nuevoAlumno
					totalAlumnos <- totalAlumnos + 1
					alumnos[totalAlumnos] <- nuevoAlumno
					totalUsuarios <- totalUsuarios + 1
					usuarios[totalUsuarios] <- nuevoAlumno
					Escribir "Defina contraseña para ", nuevoAlumno, ":"
					Leer pass
					contraseñas[totalUsuarios] <- pass
					roles[totalUsuarios] <- 3
					Escribir "Alumno creado con éxito."
					Escribir ""
					Escribir "Presione una tecla para continuar..."
					Esperar Tecla
					Limpiar Pantalla
				SiNo
					Escribir "No se pueden agregar más alumnos."
					Escribir ""
					Escribir "Presione una tecla para continuar..."
					Esperar Tecla
					Limpiar Pantalla
				FinSi
			3:
				Si totalProfesores < 10 Entonces
					Escribir "Ingrese el nombre del nuevo profesor:"
					Leer nuevoProfesor
					totalProfesores <- totalProfesores + 1
					profesores[totalProfesores] <- nuevoProfesor
					totalUsuarios <- totalUsuarios + 1
					usuarios[totalUsuarios] <- nuevoProfesor
					Escribir "Defina contraseña para ", nuevoProfesor, ":"
					Leer pass
					contraseñas[totalUsuarios] <- pass
					roles[totalUsuarios] <- 2
					Escribir "Profesor creado con éxito."
					Escribir ""
					Escribir "Presione una tecla para continuar..."
					Esperar Tecla
					Limpiar Pantalla
				SiNo
					Escribir "No se pueden agregar más profesores."
					Escribir ""
					Escribir "Presione una tecla para continuar..."
					Esperar Tecla
					Limpiar Pantalla
				FinSi
			4:
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
			5:
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
			6:
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
			7: 
				Escribir "Cerrando sesión de administrador..."
			De Otro Modo: Escribir "Opción no válida."
		FinSegun
		
	Hasta Que op = 7
FinSubProceso

// -----------------------------------------------------------------------------
// SUBPROCESO: Menú y acciones del Profesor
// -----------------------------------------------------------------------------
SubProceso MenuProfesor(materias, alumnos, profesores, materiaProfesor, notas Por Referencia, inscripciones, totalMaterias, totalAlumnos, totalProfesores, nombreProfesor)
    // --- VARIABLES LOCALES DEL SUBPROCESO ---
	Definir op, idProfesorActual, cont, i, opcionMateria, idMateria, nota Como Entero
	Dimension listaMaterias[10] // <--- AQUÍ DECLARAMOS EL ARREGLO
    // ------------------------------------------
	
	// Busca el ID del profesor actual basado en su nombre de usuario
	idProfesorActual <- BuscarIdUsuario(profesores, totalProfesores, nombreProfesor)
	
	Repetir
		Escribir "=== Menu Profesor - ", nombreProfesor, " ==="
		Escribir "1. Cargar notas"
		Escribir "2. Ver mis materias (con promedios)"
		Escribir "3. Salir"
		Leer op
		Limpiar Pantalla
		
		Si idProfesorActual > 0 Entonces
			Segun op Hacer
				1:
					cont <- 0
					Para i <- 1 Hasta totalMaterias
						Si materiaProfesor[i] = idProfesorActual Entonces
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
				2:
					cont <- 0
					Para i <- 1 Hasta totalMaterias
						Si materiaProfesor[i] = idProfesorActual Entonces
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
				3: 
					Escribir "Cerrando sesión de profesor..."
				De Otro Modo: Escribir "Opción no válida."
			FinSegun
		SiNo
			Escribir "ERROR: No se pudo encontrar el perfil del profesor."
			op <- 3 // Forzar salida si hay un error
		FinSi
		
		Si op <> 3 Entonces
			Escribir ""
			Escribir "Presione una tecla para continuar..."
			Esperar Tecla
			Limpiar Pantalla
		FinSi
		
	Hasta Que op = 3
	
FinSubProceso

// -----------------------------------------------------------------------------
// SUBPROCESO: Menú y acciones del Alumno
// -----------------------------------------------------------------------------
SubProceso MenuAlumno(materias, alumnos, notas, inscripciones Por Referencia, totalMaterias, totalAlumnos, nombreAlumno)
	Definir op Como Entero
	Definir idAlumnoActual Como Entero
	
	idAlumnoActual <- BuscarIdUsuario(alumnos, totalAlumnos, nombreAlumno)
	
	Repetir
		Escribir "=== Menu Estudiante - ", nombreAlumno, " ==="
		Escribir "1. Inscribirse en materia"
		Escribir "2. Ver mis notas y promedio"
		Escribir "3. Salir"
		Leer op
		Limpiar Pantalla
		
		Si idAlumnoActual > 0 Entonces
			Segun op Hacer
				1:
					Escribir "Materias disponibles:"
					Para i<-1 Hasta totalMaterias Hacer
						Escribir i, ". ", materias[i]
					FinPara
					Escribir "Seleccione materia para inscribirse:"
					Leer idMateria
					inscripciones[idAlumnoActual,idMateria] <- 1
					Escribir "Inscripción exitosa."
				2:
					Escribir "--- Tus Notas ---"
					suma <- 0
					cant <- 0
					Para j<-1 Hasta totalMaterias Hacer
						Si inscripciones[idAlumnoActual,j] = 1 Entonces
							Escribir materias[j], ": "
							Si notas[idAlumnoActual,j] <> 0 Entonces
								Escribir "   Nota: ", notas[idAlumnoActual,j]
								suma <- suma + notas[idAlumnoActual,j]
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
				3: Escribir "Cerrando sesión de alumno..."
				De Otro Modo: Escribir "Opción no válida."
			FinSegun
		SiNo
			Escribir "ERROR: No se pudo encontrar el perfil del alumno."
			op <- 3 // Forzar salida
		FinSi
		
		Si op <> 3 Entonces
			Escribir ""
			Escribir "Presione una tecla para continuar..."
			Esperar Tecla
			Limpiar Pantalla
		FinSi
		
	Hasta Que op = 3
FinSubProceso

// -----------------------------------------------------------------------------
// SUBPROCESO UTILITARIO: Busca un nombre en un arreglo y devuelve su índice
// -----------------------------------------------------------------------------
Funcion id <- BuscarIdUsuario(lista_nombres, total_elementos, nombre_buscar)
	Definir i, id Como Entero
	id <- 0 // Retorna 0 si no lo encuentra
	i <- 1
	Mientras i <= total_elementos Y id = 0 Hacer
		Si lista_nombres[i] = nombre_buscar Entonces
			id <- i
		FinSi
		i <- i + 1
	FinMientras
FinFuncion